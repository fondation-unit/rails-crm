class CreateLevels < ActiveRecord::Migration[8.0]
  def change
    create_table :crm_levels do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
