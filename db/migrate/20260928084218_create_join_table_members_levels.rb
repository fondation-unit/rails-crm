class CreateJoinTableMembersLevels < ActiveRecord::Migration[8.0]
  def change
    create_join_table :crm_members, :crm_levels, table_name: :crm_members_levels do |t|
      t.index [:crm_member_id, :crm_level_id]
      t.index [:crm_level_id, :crm_member_id]
    end
  end
end
