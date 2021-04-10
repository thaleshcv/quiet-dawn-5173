class CreateCurrentPriceView < ActiveRecord::Migration[6.0]
  def up
    execute <<~SQL
      CREATE MATERIALIZED VIEW current_prices AS
        SELECT p1.* FROM prices p1
        WHERE date=(
          SELECT MAX(date) FROM prices p2 WHERE p2.item_id = p1.item_id
        )
    SQL
  end

  def down
    execute "DROP MATERIALIZED VIEW IF EXISTS current_prices"
  end
end
