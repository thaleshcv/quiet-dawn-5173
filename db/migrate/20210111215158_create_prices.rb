class CreatePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :prices do |t|
      t.belongs_to :asset, null: false, foreign_key: true
      t.decimal :value, precision: 10, scale: 2, null: false
      t.decimal :low, precision: 10, scale: 2, null: false
      t.decimal :high, precision: 10, scale: 2, null: false
      t.date :date, null: false
    end

    add_index :prices, %i[asset_id date], unique: true
  end
end
