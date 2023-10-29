# frozen_string_literal: true

redis_url = ENV.fetch("REDIS_URL")
es_ca_file = ENV.fetch("ELASTICSEARCH_CERT_PATH")

Searchkick.redis = ConnectionPool.new { Redis.new(url: redis_url) }

Searchkick.client_options = {
  transport_options: {
    ssl: {
      ca_file: es_ca_file
    }
  }
}
