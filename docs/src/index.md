# Improving Search functionality for Documenter.jl

## Final Work Report for the Google Summer of Code 2025 under Julia

## Abstract

In this project I had to improve the search functionality of documenter so I did the following things :
 - The first thing I did is to [add search benchmarks](adding_search_benchmarks.md) to test that upcoming improvements.
 - Then I [created a test manual](creating_test_manual.md) and tested it on the benchmarks.
 - Then I [created a custom tokenizer](improving_tokenizer.md) so that you can now search symbols along with text and the search result now come based on a priority list which is based on user's preference.
 -  Next I investigated how can I make the search index better so me along with my mentors finalized to [remove the page category from the search index and make everything a section](listing_in_si.md) to reduce the search index size and make the search much more intuitive.
 - Also now [documenter gives you warning when your search index size exceeds a specific threshold](warn_when_si_big.md).
 - I also created a [developer doc](dev_docs_for_search.md) for explaining how search functionality works in Documenter.
 - One of my mentor suggested that we should [add navigation functionality using keyboard](key_bindings.md) in the search modal so people can navigate using up and down keys so I did that

## Pull Requests
- [Adding the complete architecture for search benchmarking](https://github.com/JuliaDocs/Documenter.jl/pull/2740)
- [Create a test manual and test it on the benchmarks](https://github.com/JuliaDocs/Documenter.jl/pull/2757)
- [Improving the tokenizer](https://github.com/JuliaDocs/Documenter.jl/pull/2744)
- [Warn when the search index size is too big](https://github.com/JuliaDocs/Documenter.jl/pull/2753)
- [Now the page category is removed and everything is concatenated into sections](https://github.com/JuliaDocs/Documenter.jl/pull/2762)
- [Navigate search modal using up and down keys](https://github.com/JuliaDocs/Documenter.jl/pull/2761)

## Contributor Info

- Name - Mohd Rahban Ghani 
-  Organization - [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl)
- Email - [rahban.ghani2001@gmail.com](mailto:rahban.ghani2001@gmail.com)
- GitHub - [Rahban1](https://github.com/Rahban1)
- Linkedin - [Rahban Ghani](https://www.linkedin.com/in/rahban-ghani/)
- Twitter - [RahbanGhani](https://x.com/RahbanGhani)     

## Mentor's Info
- [Morten Piibeleht](https://github.com/mortenpi)
- [Hetarth Shah](https://github.com/Hetarth02)


## GSoC Project Page
- [GSoC 2025 with Julia - Improving search functionality for Documenter.jl](https://summerofcode.withgoogle.com/programs/2025/projects/KGUrSI9I)

## GSoC Project Proposal
- [Project Proposal](https://docs.google.com/document/d/1gd7pBjiRPizH0S7uX4FKdIjm0J44GpFHsbJTCgMtM28/edit?usp=sharing)

This site is a collection of notes, progress reports for the [2025 Google Summer of Code (GSoC) project](https://summerofcode.withgoogle.com/programs/2025/projects/KGUrSI9I) by [@Rahban1](https://github.com/Rahban1), mentored by [@mortenpi](https://github.com/mortenpi) and [@Hetarth02](https://github.com/Hetarth02).

I thought it would be a good idea to document my journey using Documenter itself, also I was inspired by my mentor Morten who did the same :)


