import { Application } from "@hotwired/stimulus";
import SortableController from "./_sortable_controller";

const application = Application.start();
application.register("sortable", SortableController);

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };
