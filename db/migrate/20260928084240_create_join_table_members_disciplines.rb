class CreateJoinTableMembersDisciplines < ActiveRecord::Migration[8.0]
  def change
    create_join_table :crm_members,
                      :crm_disciplines,
                      table_name: :crm_members_disciplines do |t|
      t.index [:crm_member_id, :crm_discipline_id]
      t.index [:crm_discipline_id, :crm_member_id]
    end
  end
end
