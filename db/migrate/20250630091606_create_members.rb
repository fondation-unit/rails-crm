class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.string :name
      t.string :address
      t.string :zip_code
      t.string :city

      t.timestamps
    end
  end
end
