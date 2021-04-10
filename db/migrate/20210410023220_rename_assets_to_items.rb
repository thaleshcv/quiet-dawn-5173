class RenameAssetsToItems < ActiveRecord::Migration[6.0]
  def change
    rename_table :assets, :items
    rename_column :investments, :asset_id, :item_id
    rename_column :prices, :asset_id, :item_id
    # rename_column :current_prices, :asset_id, :item_id

    CurrentPrice.refresh
  end
end
