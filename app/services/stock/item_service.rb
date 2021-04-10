module Stock
  class ItemService
    include HTTParty
    base_uri "https://api.cotacoes.uol.com"

    DEFAULT_OPTIONS = {
      format: "JSON",
      fields: "abbreviation,name,id"
    }.freeze

    def initialize(format: nil, fields: nil)
      @options = {
        format: format || DEFAULT_OPTIONS[:format],
        fields: fields || DEFAULT_OPTIONS[:fields]
      }
    end

    def list(query = nil)
      if query.present?
        filter_items_by_name_or_abbreviation(fetch_all, query.strip.upcase)
      else
        fetch_all
      end
    end

    def find(item_id)
      fetch_all.find { |ass| ass["id"].to_s == item_id.to_s }
    end

    private

    def filter_items_by_name_or_abbreviation(items, query)
      items.select do |ass|
        ass["name"].include?(query) || ass["abbreviation"].include?(query)
      end
    end

    def fetch_all
      response = self.class.get("/asset/list", { query: @options })

      raise Stock::ClientError, response.message unless response.code == 200

      JSON.parse(response.body).fetch("docs")
    end
  end
end
