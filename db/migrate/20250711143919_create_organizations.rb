class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :crm_organizations do |t|
      t.string :name, null: false
      t.string :address, null: true
      t.string :zip_code, null: true
      t.string :city, null: true
      t.float :lat, null: true
      t.float :lng, null: true
      t.string :linkedin, null: true
      t.boolean :linkedin_connected, null: false, default: false
      t.integer :status, null: true
      t.string :type_orga, null: true
      t.references :user

      t.timestamps
    end

    add_index :crm_organizations, :name, unique: true

    if ActiveRecord::Base.connection.adapter_name.downcase == "postgresql"
      execute <<~SQL
        ALTER TABLE crm_organizations
        ADD COLUMN search_vector tsvector
        GENERATED ALWAYS AS (
          to_tsvector('simple',
            coalesce(name, '') || ' ' ||
            coalesce(city, '') || ' ' ||
            coalesce(address, '')
          )
        ) STORED;
      SQL

      add_index :crm_organizations, :search_vector, using: :gin
    end
  end
end
