class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.string :gender, null: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email_address, null: false
      t.string :position, null: true
      t.string :phone_number, null: true
      t.boolean :copil, null: true
      t.boolean :comex, null: true
      t.boolean :decisionnaire, null: true
      t.boolean :principal, null: true
      t.string :linkedin, null: true
      t.boolean :linkedin_connected, null: true

      t.timestamps
    end
  end


end
