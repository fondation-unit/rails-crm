class CreateJoinTableTypeMember < ActiveRecord::Migration[8.0]
  def change
    create_join_table :members, :member_types,
                      table_name: :crm_members_member_types,
                      column_options: { foreign_key: false } do |t|
      t.index %i[member_id member_type_id]
      t.index %i[member_type_id member_id]
    end

    add_foreign_key :crm_members_member_types, :crm_members, column: :member_id
    add_foreign_key :crm_members_member_types, :crm_member_types, column: :member_type_id
  end
end
