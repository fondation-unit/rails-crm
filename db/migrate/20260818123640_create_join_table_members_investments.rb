class CreateJoinTableMembersInvestments < ActiveRecord::Migration[8.0]
  def change
    create_join_table :crm_members, :crm_investments, table_name: :crm_members_investments do |t|
      t.index %i[crm_member_id crm_investment_id]
      t.index %i[crm_investment_id crm_member_id]
    end
  end
end
