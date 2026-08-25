// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "./controllers";

import "trix";
import "@rails/actiontext";
import "bootstrap";

const investment = document.querySelector("#member_investments");
const investment_div = document.querySelector("#investments");

if (investment) {
    if (investment.checked) {
        investment_div.style.display = "block";
    } else {
        investment_div.style.display = "none";
    }

    investment.addEventListener(
        "change",
        function (e) {
            if (this.checked) {
                investment_div.style.display = "block";
            } else {
                investment_div.style.display = "none";
            }
        },
        false
    );
}
