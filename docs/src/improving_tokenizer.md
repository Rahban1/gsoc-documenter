# Updating Tokenizer

## Understanding the task

A tokenizer is a component of a search engine that processes text by breaking it down into smaller units called tokens. These tokens are then indexed and used to match search queries against the content.

Right now the tokenize function in the repository in assets/html/js/search.js is :

```julia
    tokenize: (string) => string.split(/[\s\-\.]+/)
```

It splits the string into tokens using regular expression that match spaces (\s), hyphens (\-), and dots (\.) as delimiters. Consider somebody search for task_local_storage, a default tokenizer will split it into the following tokens “task”, “local”, “storage”
While this works well for general text, it can cause problems when searching for programming related content, especially in languages like Julia where identifiers often contain underscores and are meant to be treated as a single cohesive unit.

Some problems that can arise from this approach is :
- Loss of context
- Reduced precision
- Poor user experience

## The problem 

  The old tokenizer was too simple and caused these issues:

  - Problem 1: Lost Important Julia Syntax

    What happened when someone searched for "Base.sort":
    "Base.sort function" → ["Base", "sort", "function"]

    Lost the connection between "Base" and "sort"

    Why this is bad: Julia has special syntax like Base.sort where the dot (.) connects the module name to the
    function name. The old tokenizer split on dots, so it couldn't find "Base.sort" when you searched for it!

  - Problem 2: Operators Got Lost

    When someone searched for "^" (power operator):
    "Use ^ operator" → ["Use", "", "operator"]
    The "^" symbol disappeared!

  - Problem 3: Macros Broken Apart

    When someone searched for "@time" (a Julia macro):
    "@time macro" → ["", "time", "macro"]
    Lost the "@" symbol that makes it a macro!

## Solution

  - Change 1: Improving on the custom trimmer
   right now the trimmer is :
```julia
  word = word
    .replace(/^[^a-zA-Z0-9@!]+/, "")
    .replace(/[^a-zA-Z0-9@!]+$/, "")
```

Basically, what this is doing is removing every character which is not uppercase letters, lowercase letters, numbers, and two symbols '@' and '!' from the beginning and end of the query

but the problem is what if somebody search for just '^' it would result nothing
  - Change 2: Intelligent Pattern Matching

    I completely rewrote the tokenizer to understand Julia's special syntax. Here's what I did:

```julia
    // Julia-aware tokenization that preserves meaningful syntax elements
    tokenize: (string) => {
      const tokens = [];
      let remaining = string;
      
      // Julia-specific patterns to preserve as complete tokens
      const patterns = [
        // Module qualified names (e.g., Base.sort, Module.Submodule.function)
        /\b[A-Z][A-Za-z0-9_]*(?:\.[A-Z][A-Za-z0-9_]*)*\.[a-z_][A-Za-z0-9_!]*\b/g,
        // Macro calls (e.g., @time, @async)
        /@[A-Za-z_][A-Za-z0-9_]*/g,
        // Type parameters (e.g., Array{T,N}, Vector{Int})
        /\b[A-Z][A-Za-z0-9_]*\{[^}]+\}/g,
        // Function names with module qualification (e.g., Base.+, Base.:^)
        /\b[A-Z][A-Za-z0-9_]*\.:[A-Za-z0-9_!+\-*/^&|%<>=.]+/g,
        // Operators as complete tokens (e.g., !=, &&, ||, ^, .=, ->)
        /[!<>=+\-*/^&|%:.]+/g,
        // Function signatures with type annotations (e.g., f(x::Int))
        /\b[a-z_][A-Za-z0-9_!]*\([^)]*::[^)]*\)/g,
        // Regular identifiers and function names
        /\b[A-Za-z_][A-Za-z0-9_!]*\b/g,
        // Numbers (integers, floats, scientific notation)
        /\b\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\b/g
      ];
      
      // Apply patterns in order of specificity (most specific first)
      for (const pattern of patterns) {
        pattern.lastIndex = 0; // Reset regex state
        let match;
        while ((match = pattern.exec(remaining)) !== null) {
          const token = match[0].trim();
          if (token && !tokens.includes(token)) {
            tokens.push(token);
          }
        }
      }
      
      // Also split on common delimiters for any remaining content
      const basicTokens = remaining.split(/[\s\-,;()[\]{}]+/).filter(t => t.trim());
      for (const token of basicTokens) {
        if (token && !tokens.includes(token)) {
          tokens.push(token);
        }
      }
      
      return tokens.filter(token => token.length > 0);
    },
```




