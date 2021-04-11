# Set of view utilities related to +Item+ resource.
module ItemsHelper
  ##
  # Renders an autocomplete input for item selection.
  #
  # @example
  #
  # <%= form_with url: explore_items_path, method: "get", local: true do |form| %>
  #   <%= items_dropdown form, :item_id,
  #     auto_submit: true,
  #     selected_item: (@explore_facade.item if @explore_facade.present?),
  #     input_html: { class: "border-0 form-control-lg" } %>
  # <% end %>
  #
  # @param [FormBuilder] form - The form where the input is inserted.
  # @param [String|Symbol] name - A +string+ or +symbol+ with the parameter name to submit the selected item ID.
  # @param [Item] selected_item: - (optional) An item to be used as initial value.
  # @param [Hash] input_html: - (optional) A hash with HTML properties to be passed on the input. \
  # Currently, only +class+ and +data+ properties are supported.
  # @param [boolean] auto_submit: - (optional) if +true+, the form will be submitted automatically after selection.
  def items_dropdown(form, name, selected_item: nil, input_html: {}, auto_submit: false)
    raise(ArgumentError, "A form is required") if form.blank?
    raise(ArgumentError, "A name is required") if name.blank?

    input_html = input_html.symbolize_keys

    input_props = {
      class: "input #{input_html[:class]}".strip,
      data: {
        "auto-submit": auto_submit
      }
    }

    render partial: "partials/item_dropdown", locals: {
      form: form,
      name: name,
      selected_item: selected_item,
      input_html: input_props
    }
  end
end
