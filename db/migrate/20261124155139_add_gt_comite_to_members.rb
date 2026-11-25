class AddGtComiteToMembers < ActiveRecord::Migration[8.1]
  def change
    add_column :members, :gt, :boolean
    add_column :members, :comite, :boolean
  end
end
