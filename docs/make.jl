using Documenter

makedocs(
    sitename = "GSoC Documentation",
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md"
    ]
)

deploydocs(
    repo = "github.com/rahbanghani/gsoc-documentation.git"
)
