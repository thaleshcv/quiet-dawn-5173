module AssetsHelper
  def chart_range_option(asset, label, range:, disabled: false)
    button_tag(label,
      type: "button",
      disabled: disabled,
      class: "btn btn-secondary btn-sm range-#{range}",
      data: {
        remote: true,
        url: accumulated_series_asset_url(asset, ndays: range),
        method: "GET"
      })
  end
end
