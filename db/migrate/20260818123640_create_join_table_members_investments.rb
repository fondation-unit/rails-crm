class CreateJoinTableMembersInvestments < ActiveRecord::Migration[8.0]
  def change
    create_join_table :members, :investments,
                      table_name: :crm_members_investments,
                      column_options: { foreign_key: false } do |t|
      t.index %i[member_id investment_id]
      t.index %i[investment_id member_id]
    end

    add_foreign_key :crm_members_investments, :crm_members, column: :member_id
    add_foreign_key :crm_members_investments, :crm_investments, column: :investment_id
  end
end
