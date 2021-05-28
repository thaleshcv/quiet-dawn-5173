require "prawn"
require "prawn/measurement_extensions"

class PortfolioReport
  include ActionView::Helpers::NumberHelper

  PDF_OPTIONS = {
    page_size: "A4",
    page_layout: :portrait,
    margin: [40, 40]
  }.freeze

  CLIENT_WIDTH = 170.mm.freeze
  CLIENT_HEIGHT = 257.mm.freeze

  def initialize(filename, data = [])
    @filename = filename
    @data = data
  end

  def build
    Prawn::Document.new(PDF_OPTIONS) do |pdf|
      page_header(pdf)
      totals_section(pdf)

      pdf.move_down 30

      create_items_table_header(pdf)

      pdf.move_down 10

      create_items_table(pdf)

      pdf.render_file(@filename)
    end
  end

  private

  def sum_total_invested
    @sum_total_invested ||= @data.reduce(0) { |memo, item| memo + item.item_value_invested }
  end

  def sum_current_value
    @sum_current_value ||= @data.reduce(0) { |memo, item| memo + item.item_current_value }
  end

  def page_header(pdf)
    pdf.image "#{Rails.root}/app/javascript/images/logo-dark.png", at: [0, 270.mm], scale: 0.7
    pdf.text "Weekly report", size: 18, align: :right
    pdf.text Date.today.to_formatted_s(:long), align: :right
  end

  def totals_section(pdf)
    bounding_top = pdf.cursor - 30

    pdf.bounding_box([0, bounding_top], width: CLIENT_WIDTH * 0.35) do
      pdf.text "Investido", align: :right
      pdf.text number_to_currency(sum_total_invested), size: 18, align: :right
    end

    pdf.bounding_box([CLIENT_WIDTH * 0.35, bounding_top], width: CLIENT_WIDTH * 0.35) do
      pdf.text "Acumulado", align: :right
      pdf.text number_to_currency(sum_current_value), size: 18, align: :right
    end

    variation_pct = ((sum_current_value - sum_total_invested) / sum_total_invested) * 100
    pdf.bounding_box([CLIENT_WIDTH * 0.70, bounding_top], width: CLIENT_WIDTH * 0.3) do
      pdf.text "Variação", align: :right
      pdf.text number_to_percentage(variation_pct, precision: 1),
        size: 18,
        align: :right,
        color: variation_pct.negative? ? "FF0000" : "00FF00"
    end
  end

  def create_items_table_header(pdf)
    x_pos = 0
    y_pos = pdf.cursor

    # first column
    pdf.bounding_box([x_pos, y_pos], width: CLIENT_WIDTH * 0.2) do
      pdf.text "Item", size: 10
      # pdf.stroke_bounds
    end

    # second column
    pdf.bounding_box([(x_pos += CLIENT_WIDTH * 0.2), y_pos], width: CLIENT_WIDTH * 0.2) do
      pdf.text "Investido", size: 10, align: :right
      # pdf.stroke_bounds
    end

    # third column
    pdf.bounding_box([(x_pos += CLIENT_WIDTH * 0.2), y_pos], width: CLIENT_WIDTH * 0.2) do
      pdf.text "Qtd", size: 10, align: :right
      # pdf.stroke_bounds
    end

    # fourth column
    pdf.bounding_box([(x_pos += (CLIENT_WIDTH * 0.2)), y_pos], width: CLIENT_WIDTH * 0.2) do
      pdf.text "Acumulado", size: 10, align: :right
      # pdf.stroke_bounds
    end

    # fifth column
    pdf.bounding_box([(x_pos + (CLIENT_WIDTH * 0.2)), y_pos], width: CLIENT_WIDTH * 0.2) do
      pdf.text "+/-", size: 10, align: :right
      # pdf.stroke_bounds
    end
  end

  def create_items_table(pdf)
    @data.each do |row|
      x_pos = 0
      y_pos = pdf.cursor

      # first column
      pdf.bounding_box([x_pos, y_pos], width: CLIENT_WIDTH * 0.2) do
        pdf.text row.item_abbr, size: 12
        # pdf.stroke_bounds
      end

      # second column
      pdf.bounding_box([(x_pos += CLIENT_WIDTH * 0.2), y_pos], width: CLIENT_WIDTH * 0.2) do
        pdf.text number_to_currency(row.item_value_invested), size: 12, align: :right
        # pdf.stroke_bounds
      end

      # third column
      pdf.bounding_box([(x_pos += CLIENT_WIDTH * 0.2), y_pos], width: CLIENT_WIDTH * 0.2) do
        pdf.text row.item_quantity.to_s, size: 12, align: :right
        # pdf.stroke_bounds
      end

      # fourth column
      pdf.bounding_box([(x_pos += (CLIENT_WIDTH * 0.2)), y_pos], width: CLIENT_WIDTH * 0.2) do
        pdf.text number_to_currency(row.item_current_value), size: 12, align: :right
        # pdf.stroke_bounds
      end

      # fifth column
      pdf.bounding_box([(x_pos + (CLIENT_WIDTH * 0.2)), y_pos], width: CLIENT_WIDTH * 0.2) do
        value_variation_in_pct = row.value_variation_in_pct
        pdf.text number_to_percentage(value_variation_in_pct, precision: 1),
          style: :bold,
          size: 12,
          align: :right,
          color: value_variation_in_pct.negative? ? "FF0000" : "00FF00"

        # pdf.stroke_bounds
      end

      pdf.move_down 15
    end
  end
end
