class CreateJoinTableTypeMember < ActiveRecord::Migration[8.0]
  def change
    create_join_table :crm_members, :crm_member_types do |t|
      t.index %i[crm_member_id crm_member_type_id]
      t.index %i[crm_member_type_id crm_member_id]
    end
  end
end
