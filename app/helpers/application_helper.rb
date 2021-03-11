module ApplicationHelper
  def chart_range_option(label, path, range:, disabled: false)
    button_tag(label,
      type: "button",
      disabled: disabled,
      class: "btn btn-secondary btn-sm range-#{range}",
      data: {
        remote: true,
        url: path,
        method: "GET"
      })
  end

  def styled_numeric(numeric,
                     html: "span",
                     negative_class: "text-danger",
                     positive_class: "text-success")

    numeric_class = numeric.negative? ? negative_class : positive_class

    content_tag(html, class: numeric_class) do
      block_given? ? yield(numeric) : numeric
    end
  end

  def difference_in_percent(initial, current)
    # avoiding division by zero and NaN values
    if initial.to_f.zero? || current.to_f.zero?
      0
    else
      ((current / initial) - 1) * 100
    end
  end
end
