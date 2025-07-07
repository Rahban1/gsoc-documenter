using Revise
using Pkg
Pkg.activate("docs")
using Documenter, LiveServer

# Function to serve docs with hot reloading
function serve_docs()
    # Build docs first
    include("docs/make.jl")
    
    # Serve with live reload
    LiveServer.serve(dir="docs/build", port=8000)
end

println("Setup complete! Run serve_docs() to start the documentation server with hot reloading.")