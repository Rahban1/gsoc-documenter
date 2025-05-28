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
        "Deliverable Summary" => Any["adding_search_benchmarks.md",]
    ],
    build = "build",
)

deploydocs(
    repo = "github.com/Rahban1/gsoc-documenter.git",
    target = "build",
    push_preview = true
)
