class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.boolean :public, default: false
      t.string :contact_type
      t.references :user
      t.references :notable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
