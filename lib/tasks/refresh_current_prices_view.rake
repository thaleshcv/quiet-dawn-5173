task refresh_current_prices_view: :environment do
  CurrentPrice.refresh
end
