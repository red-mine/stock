class CreateStocksCoefs < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks_coefs do |t|
      t.string :stock
      t.float :coef
      t.float :inter
      t.float :price

      t.timestamps
    end
  end
end
