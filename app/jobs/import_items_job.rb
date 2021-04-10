class ImportItemsJob < ApplicationJob
  queue_as :default

  def perform
    new_items = Stock::ItemService.new.list
    Item.upsert_all(new_items, unique_by: :abbreviation)
  end
end
