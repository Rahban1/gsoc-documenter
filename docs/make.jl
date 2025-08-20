using Documenter

makedocs(
    sitename = "GSoC Documentation",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        canonical = "https://rahban1.github.io/gsoc-documenter/",
        assets = String[],
        analytics = "UA-XXXXXXXXX-X",
    ),
    pages = [
        "Home" => "index.md",
        "Deliverable Summary" => Any["adding_search_benchmarks.md", "creating_test_manual.md", "improving_tokenizer.md", "warn_when_si_big.md", "listing_in_si.md", "dev_docs_for_search.md"],
        "Additionals" => Any["key_bindings.md"],
        "Conclusion" => "conclusion.md"
    ],
    build = "build",
)

deploydocs(
    repo = "github.com/Rahban1/gsoc-documenter.git",
    target = "build",
    push_preview = true
)
