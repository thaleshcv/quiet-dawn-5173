module Stock
  class PriceService
    include HTTParty
    base_uri "https://api.cotacoes.uol.com"

    class << self
      def interday(item, size = 10)
        fetch_prices("/asset/interday/list/paged", { item: item, size: size })
      end

      def intraday(item, size = 10)
        fetch_prices("/asset/intraday/list/paged", { item: item, size: size })
      end

      private

      DEFAULT_QUERY = {
        format: "JSON",
        fields: "price,high,low,open,volume,close,bid,ask,change,pctChange,date"
      }.freeze

      def fetch_prices(endpoint, params)
        response = get(endpoint, { query: query_options(params) })

        raise(Stock::ClientError, response.message) unless response.code == 200

        JSON.parse(response.body).fetch("docs")
      end

      def query_options(options = {})
        DEFAULT_QUERY.merge(options)
      end
    end
  end
end
