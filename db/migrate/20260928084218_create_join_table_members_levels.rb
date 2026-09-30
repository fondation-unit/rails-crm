class CreateJoinTableMembersLevels < ActiveRecord::Migration[8.0]
  def change
    create_join_table :members, :levels,
                      table_name: :crm_members_levels,
                      column_options: { foreign_key: false } do |t|
      t.index [:member_id, :level_id]
      t.index [:level_id, :member_id]
    end

    add_foreign_key :crm_members_levels, :crm_members, column: :member_id
    add_foreign_key :crm_members_levels, :crm_levels, column: :level_id
  end
end
