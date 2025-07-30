class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.text :content, null: true
      t.boolean :public, default: false
      t.string :contact_type
      t.references :user
      t.references :member
      t.timestamps
    end
  end
end
