class CreateMemberTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :member_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
