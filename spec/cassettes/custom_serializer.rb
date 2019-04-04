require 'yaml'
require 'vcr/cassette/serializers/yaml'

# Remove request.headers and response.headers from the cassette,
# which contain sensitive information (e.g. authentication hash).
module Cassettes
  class CustomSerializer
    extend VCR::Cassette::EncodingErrorHandling
    extend VCR::Cassette::Serializers::YAML

    def self.serialize(hash)
      hash['http_interactions'][0]['request'].delete('headers')
      hash['http_interactions'][0]['response'].delete('headers')
      VCR::Cassette::Serializers::YAML.serialize(hash)
    end
  end
end
