class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.string :code
      t.date :date
      t.float :price

      t.timestamps
    end
  end
end
