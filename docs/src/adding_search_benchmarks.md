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


## Helper functions 

Now let's create a function that evaluate all these metrics for a single query

It'll look something like this :
```julia
function evaluate_query(search_function, query::TestQuery)
    results = search_function(query.query)

    precision = calculate_precision(results, query.expected_docs)
    recall = calculate_recall(results, query.expected_docs)
    f1 = calculate_f1(precision, recall)

    return Dict(
        "query" => query.query,
        "precision" => precision,
        "recall" => recall,
        "f1" => f1,
        "expected" => query.expected_docs,
        "actual" => results
    )
end
```

This will return a dictionary that have all the relevant results.
We still have to create the search function that will search the query in our actual search implementation.

This looks good, now we need to create a function that evaluate all metrics for a suite of queries, which would essentially be calling the ```evaluate_query``` function for array of queries, and then calculating the mean of all results for each metric and return a dictionary similar to ```evaluate_query``` function

It look something like this : 
```julia
function evaluate_all(search_function, queries)
    results = [evaluate_query(search_function, q) for q in queries]

    avg_precision = mean([r["precision"] for r in results])
    avg_recall = mean([r["recall"] for r in results])
    avg_f1 = mean([r["f1"] for r in results])

    return Dict(
        "individual_results" => results,
        "average_precision" => avg_precision,
        "average_recall" => avg_recall,
        "average_f1_score" => avg_f1
    )
end
```

## The Meeting #2

We had our weekly meeting and there were few suggested edits which we are going to implement :
 - use struct instead of dictionary to return the search results.
 - just display the overall result in the terminal and rest all of the detailed results should be written in a text file.
 - the returning struct should also contain integers like ```total_documents_retrieved, total_relevant_found``` along with float. 
 - Write short, descriptive comments explain the code
 - my mentors has advised me to open a pr, so that other people can see and give their suggestions on the work done till now how here the open pr link : [PR Link](https://github.com/JuliaDocs/Documenter.jl/pull/2740)

