class ImportOrganizationJob
  include Sidekiq::Job

  def perform(user_id, row)
    user = User.find(user_id)

    orga = Organization.find_or_initialize_by(name: row["Etablissement"])

    orga.update!(
      name: row["Etablissement"],
      zip_code: row["Code Postal"].present? ? row["Code Postal"] : nil,
      city: row["Ville"].present? ? row["Ville"] : nil,
      user_id: user.id,
      status: row["Statut"].present? ? row["Statut"] : 0
    )

    if row["Notes"].present? &&
         !Note.find_by(
           user_id: user.id,
           notable_id: orga.id,
           notable_type: "Organization"
         ).present?
      orga.notes.create!(
        user_id: user.id,
        content: MemberHelper.utf_decode(row["Notes"])
      )
    end
  end
end
