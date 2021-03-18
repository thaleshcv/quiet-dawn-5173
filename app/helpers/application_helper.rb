module ApplicationHelper
  def chart_range_option(label, path, range:, disabled: false)
    button_tag(label,
      type: "button",
      disabled: disabled,
      class: "button is-small range-#{range}",
      data: {
        remote: true,
        url: path,
        method: "GET"
      })
  end

  def styled_numeric(numeric,
                     html: "span",
                     negative_class: "has-text-danger",
                     positive_class: "has-text-success")

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
