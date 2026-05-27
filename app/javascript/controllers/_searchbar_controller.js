import { Controller } from '@hotwired/stimulus';
import loader from '../components/_loader';

export default class extends Controller {
  static targets = ['form'];

  initialize() {
    // Clear the input on page load
    // const input = this.formTarget.querySelector('.search-field') as HTMLInputElement
    // input.value = ''
  }

  search() {
    clearTimeout(this.timeout);
    const filter = document.querySelector('#filter');
    const searchResults = document.querySelector('#search_results');
    // Clear the filter selected value
    if (filter) {
      filter.value = '';
    }
    if (searchResults) {
      searchResults.innerHTML = loader;
    }
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit();
    }, 500);
  }
}
