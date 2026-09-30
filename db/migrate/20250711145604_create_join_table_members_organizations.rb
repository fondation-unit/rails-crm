class CreateJoinTableMembersOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_join_table :crm_members, :crm_organizations do |t|
      t.index %i[crm_member_id crm_organization_id]
      t.index %i[crm_organization_id crm_member_id]
    end
  end

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

  add_index :crm_members, :email_address, unique: true
  add_index :crm_members, :search_vector, using: :gin

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

  add_index :crm_organizations, :name, unique: true
  add_index :crm_organizations, :search_vector, using: :gin
end
