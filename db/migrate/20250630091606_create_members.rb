class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :crm_members do |t|
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
      t.boolean :newsletter_ressources, null: true
      t.boolean :invest, null: true
      t.integer :status, null: true, default: 0

      t.timestamps
    end

    add_index :crm_members, :email_address, unique: true

    if ActiveRecord::Base.connection.adapter_name.downcase == "postgresql"
      execute <<~SQL
        ALTER TABLE crm_members
        ADD COLUMN search_vector tsvector
        GENERATED ALWAYS AS (
          to_tsvector('simple',
            coalesce(first_name, '') || ' ' ||
            coalesce(last_name, '') || ' ' ||
            coalesce(position, '') || ' ' ||
            coalesce(email_address, '')
          )
        ) STORED;
      SQL

      add_index :crm_members, :search_vector, using: :gin
    end
  end
end
