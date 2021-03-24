require "prawn"
require "prawn/measurement_extensions"

class WeeklyReport
  include ActionView::Helpers::NumberHelper

  PDF_OPTIONS = {
    page_size: "A4",
    page_layout: :portrait,
    margin: [40, 40]
  }.freeze

  CLIENT_WIDTH = 170.mm.freeze

  def initialize(filename, data = [])
    @filename = filename
    @data = data
  end

  def generate
    Prawn::Document.new(PDF_OPTIONS) do |pdf|
      page_header(pdf)
      totals_section(pdf)

      pdf.move_down 30

      create_assets_table(pdf)

      pdf.render_file(@filename)
    end
  end

  private

  def sum_total_invested
    @sum_total_invested ||= @data.reduce(0) { |memo, item| memo + item["item_value_invested"] }
  end

  def sum_current_value
    @sum_current_value ||= @data.reduce(0) { |memo, item| memo + item["item_current_value"] }
  end

  def page_header(pdf)
    pdf.text "Weekly report", size: 32, style: :bold, align: :center
    pdf.text DateTime.now.to_formatted_s(:long), align: :center
  end

  def totals_section(pdf)
    bounding_top = pdf.cursor - 30

    pdf.bounding_box([0, bounding_top], width: CLIENT_WIDTH * 0.35) do
      pdf.text "Invested", align: :right
      pdf.text number_to_currency(sum_total_invested), size: 28, style: :bold, align: :right
    end

    pdf.bounding_box([CLIENT_WIDTH * 0.35, bounding_top], width: CLIENT_WIDTH * 0.35) do
      pdf.text "Accumulated", align: :right
      pdf.text number_to_currency(sum_current_value), size: 28, style: :bold, align: :right
    end

    variation_pct = ((sum_current_value - sum_total_invested) / sum_total_invested) * 100
    pdf.bounding_box([CLIENT_WIDTH * 0.70, bounding_top], width: CLIENT_WIDTH * 0.3) do
      pdf.text "Variation", align: :right
      pdf.text number_to_percentage(variation_pct, precision: 1), size: 28, style: :bold, align: :right
    end
  end

  def create_assets_table(pdf)
    @data.each do |row|
      x_pos = 0
      y_pos = pdf.cursor

      # first column
      pdf.bounding_box([x_pos, y_pos], width: CLIENT_WIDTH * 0.2) do
        pdf.text row["item_asset_name"], style: :bold, size: 10
        pdf.text row["item_asset_abbr"], style: :bold, size: 14
        # pdf.stroke_bounds
      end

      # second column
      pdf.bounding_box([(x_pos += CLIENT_WIDTH * 0.2), y_pos], width: CLIENT_WIDTH * 0.2) do
        pdf.text "Invested", style: :bold, size: 10, align: :right
        pdf.text number_to_currency(row["item_value_invested"]), style: :bold, size: 14, align: :right
        # pdf.stroke_bounds
      end

      # third column
      pdf.bounding_box([(x_pos += CLIENT_WIDTH * 0.2), y_pos], width: CLIENT_WIDTH * 0.2) do
        pdf.text "Date", style: :bold, size: 10, align: :right
        pdf.text Date.parse(row["position_at"]).to_formatted_s(:rfc822), style: :bold, size: 14, align: :right
        # pdf.stroke_bounds
      end

      # fourth column
      pdf.bounding_box([(x_pos += CLIENT_WIDTH * 0.2), y_pos], width: CLIENT_WIDTH * 0.2) do
        pdf.text "Quantity", style: :bold, size: 10, align: :right
        pdf.text row["item_quantity"].to_s, style: :bold, size: 14, align: :right
        # pdf.stroke_bounds
      end

      # fifth column
      pdf.bounding_box([(x_pos + (CLIENT_WIDTH * 0.2)), y_pos], width: CLIENT_WIDTH * 0.2) do
        pdf.text "Accumulated", style: :bold, size: 10, align: :right
        pdf.text number_to_currency(row["item_current_value"]), style: :bold, size: 14, align: :right
        # pdf.stroke_bounds
      end

      pdf.move_down 10
    end
  end
end
