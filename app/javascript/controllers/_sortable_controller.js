import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  sort(event: Event) {
    const target = event.currentTarget as HTMLElement;
    const column = target.dataset.sortableColumnValue;

    if (!column) return;

    const params = new URLSearchParams(window.location.search);
    const currentSort = params.get("sort");
    const currentDir = params.get("direction") || "asc";
    const direction =
      currentSort === column && currentDir === "asc" ? "desc" : "asc";

    // Set the URL params
    params.set("sort", column);
    params.set("direction", direction);

    // Build a new URL and navigate to it with Turbo
    const url = `${window.location.pathname}?${params.toString()}`;
    Turbo.visit(url);
  }
}