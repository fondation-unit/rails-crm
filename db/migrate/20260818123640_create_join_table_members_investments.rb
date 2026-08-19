class CreateJoinTableMembersInvestments < ActiveRecord::Migration[8.0]
  def change
    create_join_table :members, :investments do |t|
      t.index %i[member_id investment_id]
      t.index %i[investment_id member_id]
    end
  end
end
