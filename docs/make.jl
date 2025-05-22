using Documenter

makedocs(
    sitename = "GSoC Documentation",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        canonical = "https://rahban1.github.io/gsoc-documenter/",
        assets = String[],
        analytics = "UA-XXXXXXXXX-X"
    ),
    pages = [
        "Home" => "index.md",
        "Community-bonding Period" => "community-bonding.md",
    ],
    build = "../public",
)

deploydocs(
    repo = "github.com/Rahban1/gsoc-documentation.git",
    target = "build",
    push_preview = true
)
