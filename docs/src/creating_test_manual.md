# Creating test manual and testing it on benchmarks

### Relevant PR : [#2757](https://github.com/JuliaDocs/Documenter.jl/pull/2757)

My mentor suggested that it will be much more logical and understandable if we create a custom manual and seperate tests for it so that it is clear what we are testing and what expected docs should be 

## Initializing

So I started by creating a new file edge_case_queries.jl which will have all the testcases, the same struct 
```Julia
struct TestQuery
    query::String
    expected_docs::Vector{String}
end
```

and then I start writing tests, I wrote tests for 
- content queries that would be considered atypical
- queries for structural cases
- queries for markdown
- queries for common words
- autodocs queries
- cross reference queries
- doctests queries
- table queries

now in evaluate.jl and real_search.jl, I have to do changes in the existing functions so that it takes in the search index path as we will now send different search indexes one for this edge case and one for the original documenter docs

## Running both the benchmarks

I created a new file `run_all_benchmarks.jl` which just run the `run_benchmarks.jl` once for documenter docs and once for the new tests

```Julia
println("Running all benchmarks...")

println("\nRunning benchmarks for default search index...")
run(`julia $(@__DIR__)/run_benchmarks.jl $(@__DIR__)/../../docs/build/search_index.js all_test_queries`)

println("\nRunning benchmarks for edge case search index...")
run(`julia $(@__DIR__)/run_benchmarks.jl $(@__DIR__)/../search_edge_cases/build/search_index.js edge_case_queries`)

println("\nAll benchmarks complete.")
```

## Creating different modules on which to test

I created a seperate directory `test/search_edge_cases` to have all the related file, it has a simple make.jl which looks like this
```Julia
using Documenter

makedocs(
    root = @__DIR__,
    sitename = "Search Edge Case Tests",
    format = Documenter.HTML(
        prettyurls = false,
    ),
    pages = [
        "Home" => "index.md",
        "Atypical Content" => "atypical_content.md",
        "Structural Cases" => "structural_cases.md",
        "Markdown Syntax" => "markdown_syntax.md",
        "Common Words" => "common_words.md",
    ],
    build = "build",
)
```

then created a src directory and created md files for testing purposes

## Added in the CI also
We want to run both of these benchmarks in the CI so I added this in the CI.yml file
```yml
- name: Build search edge cases documentation  
  run: |
    cd test/search_edge_cases
    julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.develop(PackageSpec(path="../../"))'
    julia --project=. make.jl
```

## Changes in the Makefile

change the makefile to run the `run_all_benchmarks.jl` instead of running `run_benchmarks.jl`

## Reference values for the `test_edge_cases.jl`

In test/search/edge_case_benchmark_reference.json I added the reference values based on which we will see if any changes in the search index has improved the search relevance or has made it worse

```JSON
{
  "average_precision": 37.7,
  "average_recall": 83.2,
  "average_f1_score": 43.1
}
```

these are the values I got when I run it for the first time, it's only going to get better from here (hopefully!!!)



