document.addEventListener("DOMContentLoaded", function () {
    alert("ok");
    document.forms.edit_member.member[organization_name].addEventListener(
        "change",
        function (oEvent) {
            let oIdAppareil = this.form["member[organization_ids]"],
                aoOptions = this.list.options;
            oIdAppareil.value = "";
            for (let option of aoOptions) {
                if (option.value == this.value) {
                    oIdAppareil.value = option.dataset.id;
                    break;
                } //if
            } //for
        }
    );
});
