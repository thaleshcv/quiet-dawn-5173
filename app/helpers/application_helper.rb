module ApplicationHelper
  def navbar_user_avatar
    html = <<~HTML
      <svg style="border-radius:50%;" width="36" height="36"
        xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Avatar"
        preserveAspectRatio="xMidYMid slice" focusable="false">
        <title>#{current_user.username}</title>
        <rect width="100%" height="100%" fill="#6c757d"></rect>
        <image href="#{current_user.avatar.url}" x="2" y="2" height="32px" width="32px" />
      </svg>
    HTML

    html.html_safe
  end

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
