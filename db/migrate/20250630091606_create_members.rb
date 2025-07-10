class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email_address, null: true
      t.string :address
      t.string :zip_code
      t.string :city

      t.timestamps
    end
  end
end
