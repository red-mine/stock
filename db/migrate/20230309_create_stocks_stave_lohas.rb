class CreateStocksStaveLohas < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks_stave_lohas do |t|
      t.string  :stock
      t.float   :price
      t.date    :date
      t.integer :years
    end
  end
end
