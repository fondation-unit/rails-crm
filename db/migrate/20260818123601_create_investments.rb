class CreateInvestments < ActiveRecord::Migration[8.0]
  def change
    create_table :crm_investments do |t|
      t.string :name, null: false
      t.string :referent1, null: false
      t.string :referent2, null: false
      t.string :copy, null: false
      t.timestamps
    end
  end
end
