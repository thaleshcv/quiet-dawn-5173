module ApplicationHelper
  def difference_in_pct(initial, current)
    ((current / initial) - 1) * 100
  end

  def gain_loss(initial, current)
    difference = ((current / initial) - 1) * 100
    color = difference.negative? ? "danger" : "success"
    arrow = (difference.negative? ? "&#10136;" : "&#10138;").html_safe

    content_tag(:span, class: "text-#{color}") do
      concat(number_to_percentage(difference, precision: 1))
      concat(content_tag(:span, arrow))
    end
  end
end
