# Navigate the Search Results using up and down keys

### Related PR : [#2761](https://github.com/JuliaDocs/Documenter.jl/pull/2761)

## Initial Approach

for this I created a custom event to reset keyboard navigation selection and will be sending this event through the `document` object

```javascript
document.dispatchEvent(new CustomEvent("search-results-updated"));
 ```


