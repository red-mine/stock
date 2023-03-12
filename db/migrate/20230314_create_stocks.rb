class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :stock
      t.float :price
      t.date :date
    end
  end
end
