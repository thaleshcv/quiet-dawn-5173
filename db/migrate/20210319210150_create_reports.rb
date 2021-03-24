class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :delivered_at
      t.json :payload, null: false

      t.timestamps
    end
  end
end
