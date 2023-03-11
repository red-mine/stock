class CreateStocksStavs < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks_stavs do |t|
      t.string  :stock
      t.float   :price
      t.date    :date
    end
  end
end