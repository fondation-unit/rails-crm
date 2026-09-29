import { Application } from "@hotwired/stimulus";
import SortableController from "./_sortable_controller";
import SearchBarController from "./_searchbar_controller";
import MemberEditController from "./_member_edit_controller";

const application = Application.start();
application.register("sortable", SortableController);
application.register("search-bar", SearchBarController);
application.register("member-edit", MemberEditController);

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };
