module Stock
  class PriceService
    include HTTParty
    base_uri "https://api.cotacoes.uol.com"

    class << self
      def list(item, size = 10)
        response = get("/asset/interday/list/paged", {
                         query: query_options({ item: item, size: size })
                       })

        raise(Stock::ClientError, response.message) unless response.code == 200

        JSON.parse(response.body).fetch("docs")
      end

      private

      DEFAULT_QUERY = {
        format: "JSON",
        fields: "price,low,high,date"
      }.freeze

      def query_options(options = {})
        DEFAULT_QUERY.merge(options)
      end
    end
  end
end
