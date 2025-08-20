# Navigate the Search Results using up and down keys

### Related PR : [#2761](https://github.com/JuliaDocs/Documenter.jl/pull/2761)

## Initial Approach

for this I created a custom event to reset keyboard navigation selection and will be sending this event through the `document` object in search.js

```JavaScript
document.dispatchEvent(new CustomEvent("search-results-updated"));
```

In assets/html/js/shortcut.js I updated the footer with instruction to toggle using up and down keys : 
```HTML
<footer class="modal-card-foot is-flex is-justify-content-space-between is-align-items-center">
      <div class="is-flex gap-3 is-flex-wrap-wrap">
        <span>
          <kbd class="search-modal-key-hints">Ctrl</kbd> +
          <kbd class="search-modal-key-hints">/</kbd> to search
        </span>
        <span> <kbd class="search-modal-key-hints">esc</kbd> to close </span>
      </div>
      <div class="is-flex gap-3 is-flex-wrap-wrap">
        <span>
          <kbd class="search-modal-key-hints">↑</kbd>
          <kbd class="search-modal-key-hints">↓</kbd> to navigate
        </span>
        <span> <kbd class="search-modal-key-hints">Enter</kbd> to select </span>
      </div>
    </footer>
```

and the logic I used to render the change is to have a variable 
```JavaScript
let selectedResultIndex = -1;
```
and added an event listener to update the whenver an up key or a down key is pressed and it increments or decrements the `selectedResultIndex` respectively and call the `updatedSelectedResult()`
```JavaScript
const searchResults = document.querySelectorAll(".search-result-link");

      if (event.key === "ArrowDown") {
        event.preventDefault();
        if (searchResults.length > 0) {
          selectedResultIndex = (selectedResultIndex + 1) % searchResults.length;
          updateSelectedResult(searchResults);
        }
      } else if (event.key === "ArrowUp") {
        event.preventDefault();
        if (searchResults.length > 0) {
          selectedResultIndex = selectedResultIndex <= 0 ? searchResults.length - 1 : selectedResultIndex - 1;
          updateSelectedResult(searchResults);
        }
      } else if (event.key === "Enter" && selectedResultIndex >= 0 && searchResults.length > 0) {
        event.preventDefault();
        searchResults[selectedResultIndex].click();
      }
```
the `updatedSelectedResult()` change the highlighting from the previous selection to the current selection depending on the value of selectedResultIndex
```JavaScript
function updateSelectedResult(searchResults) {
    // Remove previous highlighting
    searchResults.forEach(result => result.classList.remove('search-result-selected'));

    // Add highlighting to current selection
    if (selectedResultIndex >= 0 && selectedResultIndex < searchResults.length) {
      const selectedResult = searchResults[selectedResultIndex];
      selectedResult.classList.add('search-result-selected');
      selectedResult.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
    }
  }
```

## Change in approach

this was working but my mentor [Hetarth Shah](https://github.com/Hetarth02) correctly mentioned that it is over-engineered in the sense that you already have a :focus element which you can use and avoid all these complexity.

I them implemented the :focus approach which honestly was much more simpler, clear and easy to read
No creating custom event, no need of selectedResultIndex variable

just simply doing : 
```JavaScript
if (searchResults.length > 0) {
          const currentFocused = document.activeElement;
          const currentIndex = Array.from(searchResults).indexOf(currentFocused);
          const nextIndex = currentIndex < searchResults.length - 1 ? currentIndex + 1 : 0;
          searchResults[nextIndex].focus();
        }
```

oh beautiful and much more readable. Thank you [Hetarth Shah](https://github.com/Hetarth02)