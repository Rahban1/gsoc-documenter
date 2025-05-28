# Adding Search Benchmarks

We had our first meeting, and we discussed what would be the flow of the entire internshiop and also discussed how to go about the first deliverable as per the proposal which is **Adding Search Benchmarks**.  

We discussed what should be the language of choice for writing scripts for benchmarking, we had two possible candidates, one was Julia (for obvious reasons, since the whole repo is in Julia) and the other one was JavaScript since the search functionality is implemented in JavaScript so it would be easier to interact with the search functionality.  

We talked about it and thought of JavaScript as a better choice but now I think of it, I belive the barebone architecture for benchmarks should be in Julia only so that in future if anybody want to add more benchmarks or new tests they can do it easily as I am expecting most of the people coming in the Documenter repo are coming from Julia background and as far as talking to the JavaScript based search functionality we can see how to talk it through Julin in coming days.

## Creating query structure

First we'll create a new directory in test folder, I have named it **search**.
Inside it I have created the first file named **test_queries.jl**

The file structure look like this :

```
test/
├─search/
│   └─test_queries.jl
...
```

I started with creating a basic struct which stores the search query and what should be the expected docs in the following manner :

```
struct TestQuery
    query::String
    expected_docs::Vector{String}
end
```

we can then compare it with the actual result and find out the different benchmarks.

Now we can create different groups of queries like basic queries or queries specific to Julia syntax and if anybody from the community want to test some queries specific to their usecase, they can do it easily. We can then use them all together using something like vcat which will concatenate all the arrays into one
 
## Evaluation 

For now, I am using three metrics for calculating benchmarks namely :

- Precision 
    - measures how many of the returned results are relevant.
    - *Example*: if you returned 5 docs, out of which 3 are relevant, precision = 3/5 = 0.6.
- Recall 
    - measures how many of the true relevant documents were found in the result.
    - *Example*: if there were 4 relevant docs and you returned 3 of them, recall = 3/4 = 0.75.
- F1 Score 
    - harmonic mean of precision and recall.
    - this balances precision and recall in a single number.
    - $F_1 = 2 \times \frac{\text{precision} \times \text{recall}}{\text{precision} + \text{recall}}$



I have create utility functions to measure each search quality, a wrapper to evaluate one query and another wrapper to run a whole set of queries and summarize the results.