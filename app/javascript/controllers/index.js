import { Application } from "@hotwired/stimulus";
import SortableController from "./_sortable_controller";
import SearchBarController from "./_searchbar_controller";
import _filter_controller from "./_filter_controller";

const application = Application.start();
application.register("sortable", SortableController);
application.register("search-bar", SearchBarController);
application.register("filters", _filter_controller);

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };
