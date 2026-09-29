class CreateJoinTableMembersLevels < ActiveRecord::Migration[8.0]
  def change
    create_join_table :members, :levels, table_name: :members_levels do |t|
      # t.index [:member_id, :level_id]
      # t.index [:level_id, :member_id]
    end
  end
end
