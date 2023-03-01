class CreateStocksCoefs < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks_coefs do |t|
      t.string  :stock
      t.float   :coef
      t.float   :inter
      t.float   :price
      t.boolean :good
      t.integer :stave
      t.date    :date

      t.timestamps
    end
  end
end
