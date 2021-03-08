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

  def difference_in_percent(initial, current)
    # avoiding division by zero and NaN values
    difference = if initial.to_f.zero? || current.to_f.zero?
      0
    else
      ((current / initial) - 1) * 100
    end

    color = difference.negative? ? "danger" : "success"

    content_tag(:span, class: "text-#{color}") do
      concat(number_to_percentage(difference, precision: 1))
    end
  end
end
