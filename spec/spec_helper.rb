require 'rspec'
require 'webmock/rspec'
require 'vcr'
require 'scale'
require 'cassettes/custom_serializer'

# by default, rspec use local vcr cassettes to mock client - server
# communication; to run tests against production server (or update
# cassettes), set SCALE_TEST_API_KEY, and run rspec with
# SCALE_TEST_SERVER=production, which is encapsulated in rake task
# spec:production
SCALE_TEST_API_KEY = ENV['SCALE_TEST_API_KEY'] || 'test_api_key'
SCALE_TEST_SERVER = ENV['SCALE_TEST_SERVER'] || 'local'

RSpec.configure do |config|
  config.include WebMock::API
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.cassette_serializers[:yaml] = Cassettes::CustomSerializer
  c.default_cassette_options = {
    record: SCALE_TEST_SERVER == 'production' ? :all : :once
  }
end
