class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :address, null: true
      t.string :zip_code, null: true
      t.string :city, null: true
      t.float :lat, null: true
      t.float :lng, null: true
      t.string :linkedin, null: true
      t.boolean :linkedin_connected, null: true
      t.integer :status, null: true
      t.string :type_orga, null: true

      t.timestamps
    end
  end
end
