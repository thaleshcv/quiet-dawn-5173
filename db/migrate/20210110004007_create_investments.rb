class CreateInvestments < ActiveRecord::Migration[6.0]
  def change
    create_table :investments do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :asset, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.money :value_invested, null: false
      t.date :invested_at, null: false

      t.timestamps
    end
  end
end
