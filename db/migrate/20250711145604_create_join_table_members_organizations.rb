class CreateJoinTableMembersOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_join_table :members, :organizations do |t|
      t.index %i[member_id organization_id]
      t.index %i[organization_id member_id]
    end
  end

  execute <<~SQL
      ALTER TABLE members
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

  add_index :members, :email_address, unique: true
  add_index :members, :search_vector, using: :gin

  execute <<~SQL
      ALTER TABLE organizations
      ADD COLUMN search_vector tsvector
      GENERATED ALWAYS AS (
        to_tsvector('simple',
          coalesce(name, '') || ' ' ||
          coalesce(city, '') || ' ' ||
          coalesce(address, '')
        )
      ) STORED;
    SQL

  add_index :organizations, :name, unique: true
  add_index :organizations, :search_vector, using: :gin
end
