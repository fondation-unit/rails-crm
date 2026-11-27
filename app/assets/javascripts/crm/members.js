document.addEventListener('DOMContentLoaded', () => {
  const organizationNameField =
    document.forms.edit_member?.elements['member[organization_name]'];
  if (!organizationNameField) return;

  organizationNameField.addEventListener('change', function () {
    const organizationIdField = this.form.elements['member[organization_ids]'];
    const optionsData = [...this.list.options].find(
      option => option.value === this.value
    );

    organizationIdField.value = optionsData?.dataset.id || '';
  });
});
