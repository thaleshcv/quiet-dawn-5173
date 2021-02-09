module ApplicationHelper
  def gain_loss(initial, current)
    difference = if current.to_i.positive? && initial.to_i.positive?
      ((current / initial) - 1) * 100
    else
      0
    end

    color = difference.negative? ? "danger" : "success"
    arrow = (difference.negative? ? "&#10136;" : "&#10138;").html_safe

    content_tag(:span, class: "text-#{color}") do
      concat(number_to_percentage(difference, precision: 1))
      concat(content_tag(:span, arrow))
    end
  end
end
