import { Controller } from "@hotwired/stimulus";
import loader from "../components/loader";

export default class extends Controller {
  static targets = ["form"];

  declare timeout: any;
  declare formTarget: HTMLFormElement;

  initialize(): void {
    // Clear the input on page load
    // const input = this.formTarget.querySelector('.search-field') as HTMLInputElement
    // input.value = ''
  }

  search() {
    clearTimeout(this.timeout);

    const filter = document.querySelector("#filter") as HTMLInputElement;
    const searchResults = document.querySelector(
      "#search_results"
    ) as HTMLDivElement;

    // Clear the filter selected value
    if (filter) {
      filter.value = "";
    }

    if (searchResults) {
      searchResults.innerHTML = loader;
    }

    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit();
    }, 500);
  }
}