module Stock
  class AssetService
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
        filter_assets_by_name_or_abbreviation(fetch_all, query.strip.upcase)
      else
        fetch_all
      end
    end

    private

    def filter_assets_by_name_or_abbreviation(assets, query)
      assets.select do |ass|
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
