class CreateStocksCoefsYears < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks_coefs_years do |t|
      t.string  :stock
      t.float   :coef
      t.float   :inter
      t.float   :price
      t.boolean :good
      t.string  :stave
      t.integer :boll
      t.integer :stav
      t.date    :date
      t.integer :years
    end
  end
end
