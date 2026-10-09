class CreateJoinTableMembersOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_join_table :members,
                      :organizations,
                      table_name: :crm_members_organizations,
                      column_options: {
                        foreign_key: false
                      } do |t|
      t.index %i[member_id organization_id]
      t.index %i[organization_id member_id]
    end

    add_foreign_key :crm_members_organizations, :crm_members, column: :member_id
    add_foreign_key :crm_members_organizations,
                    :crm_organizations,
                    column: :organization_id
  end
end
