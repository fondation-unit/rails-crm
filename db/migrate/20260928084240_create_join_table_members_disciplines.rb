class CreateJoinTableMembersDisciplines < ActiveRecord::Migration[8.0]
  def change
    create_join_table :members,
                      :disciplines,
                      table_name: :members_disciplines do |t|
      # t.index [:member_id, :discipline_id]
      # t.index [:discipline_id, :member_id]
    end
  end
end
