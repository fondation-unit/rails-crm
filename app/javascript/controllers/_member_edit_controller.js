import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    initialize() {
        const investment = document.querySelector("#member_investments");
        investment.addEventListener(
            "change",
            function (e) {
                alert("ok");
                if (this.value == 1) {
                    investment.style.display = "true";
                } else {
                    investment.style.display = "none";
                }
            },
            false
        );
    }
}
