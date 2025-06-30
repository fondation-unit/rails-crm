class CreateJoinTableTypeMember < ActiveRecord::Migration[8.0]
  def change
    create_join_table :members, :member_types do |t|
      # t.index [:member_id, :member_type_id]
      # t.index [:member_type_id, :member_id]
    end
  end
end
