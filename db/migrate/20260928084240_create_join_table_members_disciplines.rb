class CreateJoinTableMembersDisciplines < ActiveRecord::Migration[8.0]
  def change
    create_join_table :members, :disciplines,
                      table_name: :crm_members_disciplines,
                      column_options: { foreign_key: false } do |t|
      t.index [:member_id, :discipline_id]
      t.index [:discipline_id, :member_id]
    end

    add_foreign_key :crm_members_disciplines, :crm_members, column: :member_id
    add_foreign_key :crm_members_disciplines, :crm_disciplines, column: :discipline_id
  end
end
