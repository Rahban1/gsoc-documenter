using Documenter

makedocs(
    sitename = "GSoC Documentation",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        canonical = "https://rahbanghani.github.io/gsoc-documentation/",
        assets = String[],
        analytics = "UA-XXXXXXXXX-X"
    ),
    pages = [
        "Home" => "index.md",
        "Community-bonding Period" => "community-bonding.md",
    ]
)

deploydocs(
    repo = "github.com/rahbanghani/gsoc-documentation.git",
    target = "build",
    push_preview = true
)
