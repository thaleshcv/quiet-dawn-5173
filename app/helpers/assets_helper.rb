module AssetsHelper
  def chart_range_option(asset, label, range:, disabled: false)
    button_tag(label,
      type: "button",
      disabled: disabled,
      class: "btn btn-secondary btn-sm range-#{range}",
      data: {
        remote: true,
        url: accumulated_asset_url(asset, range_type: range),
        method: "GET"
      })
  end
end
