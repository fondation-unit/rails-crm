class CreateMemberTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :crm_member_types do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
