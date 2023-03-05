class CreateStocksCoefsStavs < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks_coefs_stavs do |t|
      t.string  :stock
      t.float   :coef
      t.float   :year
      t.float   :inter
      t.float   :price
      t.boolean :good
      t.string  :stave
      t.date    :date
      t.integer :years

      t.timestamps
    end
  end
end
