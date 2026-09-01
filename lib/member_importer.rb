require "csv"

class MemberImporter
  def initialize(file, user:)
    @file = file
    @user = user
  end

  def call
    CSV.foreach(
      @file.path,
      headers: true,
      encoding: "bom|utf-8",
      col_sep: ";"
    ) { |row| import_member(row) }
  end

  private

  attr_reader :user

  def import_member(row)
    member = create_or_update_member(row)

    create_note(member, row["Notes"]) if row["Notes"].present?
  end

  def create_or_update_member(row)
    member = Member.find_or_initialize_by(email_address: row["email_address"])
    member.update!(member_attributes(row))

    member
  end

  def member_attributes(row)
    {
      first_name: decode(row["first_name"]),
      last_name: decode(row["last_name"]),
      email_address: row["email_address"],
      phone_number: nil,
      copil: yes?(row["copil (oui/non)"]),
      comex: yes?(row["comex (oui/non)"]),
      newsletter_ressources: yes?(row["newsletter_ressources (oui/non)"]),
      invest: investment_selected?(row),
      investment_ids: investment_ids(row)
    }
  end

  def create_note(member, content)
    member.notes.create!(user_id: user.id, content: decode(content))
  end

  def investment_selected?(row)
    investment_ids(row).any?
  end

  def investment_ids(row)
    {
      "Donner son contenu  (oui/non)" => 1,
      "Participer a la relecture  (oui/non)" => 2,
      "Tester les ressources  (oui/non)" => 3,
      "Identifier les besoins/manques  (oui/non)" => 4
    }.filter_map { |column, id| id if yes?(row[column]) }
  end

  def yes?(value)
    value.to_s.casecmp("oui").zero?
  end

  def decode(value)
    MemberHelper.utf_decode(value)
  end
end
