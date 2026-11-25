class AddEvofiaToMembers < ActiveRecord::Migration[8.1]
  def change
    add_column :members, :evofia, :boolean
  end
end
