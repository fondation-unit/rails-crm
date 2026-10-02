import { Application } from "@hotwired/stimulus";
import SortableController from "./controllers/_sortable_controller";
import SearchBarController from "./controllers/_searchbar_controller";
import MemberEditController from "./controllers/_member_edit_controller";

const application = Application.start();
application.register("sortable", SortableController);
application.register("search-bar", SearchBarController);
application.register("member-edit", MemberEditController);

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };
