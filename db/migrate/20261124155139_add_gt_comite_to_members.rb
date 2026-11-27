class AddGtComiteToMembers < ActiveRecord::Migration[8.1]
  def change
    add_column :crm_members, :gt, :boolean
    add_column :crm_members, :comite, :boolean
  end
end
