# This migration comes from stave (originally 20230311)
class CreateStaveStaves < ActiveRecord::Migration[7.0]
  def change
    create_table :staves_stavs do |t|
      t.string :stock
      t.float :price
      t.date :date

      t.integer :years
    end
  end
end
