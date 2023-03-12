class CreateStocksStaveYears < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks_stave_years do |t|
      t.string  :stock
      t.float   :price
      t.date    :date
      t.string  :years
    end
  end
end
