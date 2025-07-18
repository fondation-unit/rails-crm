class CreateJoinTableMembersOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_join_table :members, :organizations do |t|
      t.index %i[member_id organization_id]
      t.index %i[organization_id member_id]
    end
  end
end
