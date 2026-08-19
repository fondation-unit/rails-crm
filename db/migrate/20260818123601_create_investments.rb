class CreateInvestments < ActiveRecord::Migration[8.0]
  def change
    create_table :investments do |t|
      t.string :name, null: false
      t.string :email_address, null: false
      t.timestamps
    end
  end
end
