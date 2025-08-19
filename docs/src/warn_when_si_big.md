# Warn when the search index is too big

### Relevant PR : [#2753](https://github.com/JuliaDocs/Documenter.jl/pull/2753)

## Finding the threshold

As discussed in [#2423](https://github.com/JuliaDocs/Documenter.jl/issues/2423) that we should warn when the search index is too big as are already warning if the HTML files are too big

Initial problem was deciding on the threshold size for warning, so my mentor suggested that I look at some common repo's search indexes to find the mean search index size

here are some search index sizes for documentation of common Julia repo's

- Julia - 993KB
- Documenter - 115KB
- IJulia - 16Kb
- Polymake.jl - 12.4KB
- DifferentialEquations.jl - 175 kb
- Enzyme.jl - 43.2 kb
- Oceananigans.jl - 239 kb
- Symbolics.jl - 42.4 kb
- ModelingToolkit.jl - 136 kb

Initially I thought we should give a warning and also an error if the size if too big, but then [asinghvi17](https://github.com/asinghvi17) mentioned that error will stop users from building large docs and we don't want that so we will only give a warning and not an error.

we end up with 500 kb as a threshold for warning the user that the search index size is getting a little too big

## Implementation

I implemented this code in `HTMLWriter.jl` as the previous warnings are also there only 

I created a new variable `search_size_threshold_warn::Int` and initialized it with 500 * 2^10 (500 KiB)

and created a single if condition
```julia
let file_size = filesize(search_index_path)
        if file_size > settings.search_size_threshold_warn
            file_size_format_results = format_units(file_size)
            size_threshold_warn_format_results = format_units(settings.search_size_threshold_warn)
            @warn """
            Generated search index over size_threshold_warn limit:
                Generated file size: $(file_size_format_results)
                search_size_threshold_warn: $(size_threshold_warn_format_results)
                Search index file:   $(search_index_path)
            """
        end
```

and we are all done!!!