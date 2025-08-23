# Documenter.jl Search System Developer Documentation

## Overview

The search system in Documenter.jl provides full-text search functionality for generated documentation sites. It consists of two main components: a Julia-based index generation system that runs during documentation build time, and a JavaScript-based client-side search interface that provides real-time search functionality to users.

## Architecture

The search system follows a build-time indexing and client-side search architecture:

1. **Build-time Index Generation** (`src/html/HTMLWriter.jl`)
2. **Client-side Search Interface** (`assets/html/js/search.js`)
3. **Web Worker Processing** (for performance optimization)

## Index Generation Process

### 1. SearchRecord Structure

The core data structure is the `SearchRecord` struct defined in `src/html/HTMLWriter.jl:656`:

```julia
struct SearchRecord
    src::String          # URL/path to the document
    page::Documenter.Page # Reference to the page object
    fragment::String     # URL fragment (for anchored content)
    category::String     # Content category (page, section, docstring, etc.)
    title::String        # Display title for search results
    page_title::String   # Title of the containing page
    text::String         # Searchable text content
end
```

### 2. Index Generation Pipeline

The search index is built during HTML generation through the following process:

1. **Content Traversal**: The system traverses each page's markdown AST (`src/html/HTMLWriter.jl:1752`)
2. **Record Creation**: For each content node, a `SearchRecord` is created using the `searchrecord()` function (`src/html/HTMLWriter.jl:748`)
3. **Content Categorization**: Different content types are categorized:
   - Pages: `category = "page"`
   - Sections/Headers: `category = "section"` (`src/html/HTMLWriter.jl:728`)
   - Docstrings: `category = "docstring"` 
   - Other content: `category = "page"`
4. **Text Extraction**: Content is flattened into searchable text using the `mdflatten()` function
5. **Deduplication**: Records with the same location are merged to reduce index size
6. **Serialization**: The final index is serialized to JavaScript format

### 3. Index Output

The search index is written to `search_index.js` in the following format:

```javascript
var documenterSearchIndex = {"docs": [
  {
    "location": "page.html#fragment",
    "page": "Page Title", 
    "title": "Content Title",
    "category": "section",
    "text": "Searchable content text..."
  }
  // ... more records
]}
```

### 4. Content Filtering

Certain content types are excluded from indexing (`src/html/HTMLWriter.jl:743`):
- `MetaNode` - Metadata blocks
- `DocsNodesBlock` - Documentation node blocks  
- `SetupNode` - Setup blocks

## Client-Side Search Implementation

### 1. Search Architecture

The client-side search uses a **Web Worker** architecture for performance:

- **Main Thread**: Handles UI interactions, filters, and DOM updates
- **Web Worker**: Performs search operations using MiniSearch library

### 2. MiniSearch Configuration

The search system uses MiniSearch with the following configuration (`assets/html/js/search.js:189`):

```javascript
let index = new MiniSearch({
  fields: ["title", "text"],           // Fields to index
  storeFields: ["location", "title", "text", "category", "page"], // Fields to return
  processTerm: (term) => {
    // Custom term processing with stop words removal
    // Preserves Julia-specific symbols (@, !)
  },
  tokenize: (string) => string.split(/[\s\-\.]+/), // Custom tokenizer
  searchOptions: {
    prefix: true,       // Enable prefix matching
    boost: { title: 100 }, // Boost title matches
    fuzzy: 2           // Enable fuzzy matching
  }
});
```

### 3. Stop Words

The system includes a comprehensive stop words list (`assets/html/js/search.js:81`) derived from Lunr 2.1.3, with Julia-specific exclusions to preserve important Julia keywords.

### 4. Search Workflow

#### Main Thread Process:
1. **Input Handling**: User types in search box → triggers `input` event
2. **Worker Communication**: If worker not busy → launch search via `postMessage`
3. **Result Processing**: Worker returns results → filter and display
4. **URL Updates**: Search queries and filters update browser URL

#### Web Worker Process:
1. **Query Processing**: Receive search query from main thread
2. **Search Execution**: Run MiniSearch with scoring threshold (score ≥ 1)
3. **Result Generation**: Create HTML for up to 200 results per category
4. **Return Results**: Send formatted results back to main thread

### 5. Result Rendering

Search results include (`assets/html/js/search.js:264`):
- **Title**: Highlighted with category badge
- **Snippet**: Text excerpt with search term highlighting
- **Link**: Direct link to content location
- **Context**: Page information and location path

### 6. Filtering System

The search interface provides category-based filtering:
- Filters are generated dynamically from available categories
- Users can filter by content type (page, section, docstring, etc.)
- Filtering is applied client-side for immediate response

## Performance Optimizations

### 1. Web Worker Usage
- Offloads search computation from main thread
- Maintains UI responsiveness during search operations
- Handles concurrent search requests efficiently

### 2. Result Limiting
- Pre-filters to 200 unique results per category
- Prevents excessive DOM manipulation
- Reduces memory usage for large documentation sites

### 3. Index Deduplication
- Merges duplicate entries at build time
- Reduces index size and network transfer
- Improves search performance

### 4. Progressive Loading
- Search index loads asynchronously
- Fallback handling for missing dependencies
- Graceful degradation without search functionality

## Configuration Options

### Build-Time Settings

```julia
# In make.jl
makedocs(
    # ... other options
    format = Documenter.HTML(
        # Search-related settings
        search_size_threshold_warn = 200_000  # Warn if index > 200KB
    )
)
```

### Size Thresholds
- Warning threshold: 200KB by default
- Large indices may impact page load performance
- Automatic warnings during build process

## Integration Points

### 1. Asset Management
- Search JavaScript is bundled with other Documenter assets
- MiniSearch library loaded from CDN (`__MINISEARCH_VERSION__` placeholder)
- Dependencies managed through `JSDependencies.jl`

### 2. Theme Integration  
- Search UI styled using Bulma CSS framework
- Responsive design for mobile devices
- Dark/light theme support

### 3. URL Routing
- Search queries persist in URL parameters (`?q=search_term`)
- Filter states maintained in URL (`?filter=section`)
- Browser history integration for navigation

## Testing and Benchmarking

### 1. Test Infrastructure
- Real search testing: `test/search/real_search.jl`
- Benchmark suite: `test/search/run_benchmarks.jl`
- Edge case testing: `test/search_edge_cases/`

### 2. Search Validation
The testing system provides:
- Index generation validation
- Search result accuracy verification  
- Performance benchmarking capabilities
- Edge case handling verification


