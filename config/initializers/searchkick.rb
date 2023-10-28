# frozen_string_literal: true

Searchkick.redis = ConnectionPool.new { Redis.new }

Searchkick.client_options = {
  transport_options: {
    ssl: {
      ca_file: ENV.fetch("ELASTICSEARCH_CERT_PATH")
    }
  }
}
