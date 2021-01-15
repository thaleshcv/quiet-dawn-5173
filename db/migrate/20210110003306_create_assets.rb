class CreateAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :assets do |t|
      t.string :abbreviation, null: false
      t.string :name, null: false
    end

    add_index :assets, :abbreviation, unique: true
  end
end
