class CreateStocksBollsYears < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks_bolls_years do |t|
      t.string  :stock
      t.float   :price
      t.date    :date
      t.string  :years
    end
  end
end
