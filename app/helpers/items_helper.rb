# Set of view utilities related to +Asset+ resource.
module AssetsHelper
  ##
  # Renders an autocomplete input for asset selection.
  #
  # @example
  #
  # <%= form_with url: explore_assets_path, method: "get", local: true do |form| %>
  #   <div class="form-group border-bottom">
  #     <%= assets_dropdown form, :asset_id,
  #       auto_submit: true,
  #       selected_asset: (@explore_facade.asset if @explore_facade.present?),
  #       input_html: { class: "border-0 form-control-lg" } %>
  #   </div>
  # <% end %>
  #
  # @param [FormBuilder] form - The form where the input is inserted.
  # @param [String|Symbol] name - A +string+ or +symbol+ with the parameter name to submit the selected asset ID.
  # @param [Asset] selected_asset: - (optional) An asset to be used as initial value.
  # @param [Hash] input_html: - (optional) A hash with HTML properties to be passed on the input. \
  # Currently, only +class+ and +data+ properties are supported.
  # @param [boolean] auto_submit: - (optional) if +true+, the form will be submitted automatically after selection.
  def assets_dropdown(form, name, selected_asset: nil, input_html: {}, auto_submit: false)
    raise(ArgumentError, "A form is required") if form.blank?
    raise(ArgumentError, "A name is required") if name.blank?

    input_html = input_html.symbolize_keys

    input_props = {
      class: "input #{input_html[:class]}".strip,
      data: {
        "auto-submit": auto_submit
      }
    }

    render partial: "partials/asset_dropdown", locals: {
      form: form,
      name: name,
      selected_asset: selected_asset,
      input_html: input_props
    }
  end
end
