require 'securerandom'
require 'scale/api'
require 'scale/api/errors'

RSpec.describe Scale do
  describe '.validate_api_key' do
    it 'rejects short api key' do
      expect{
        Scale.validate_api_key(SecureRandom.base64(4))
      }.to raise_error Scale::Api::APIKeyInvalid
    end

    it 'accepts test key' do
      expect{
        Scale.validate_api_key("test_#{SecureRandom.base64(4)}")
      }.to_not raise_error
    end

    it 'accepts live key' do
      expect{
        Scale.validate_api_key("live_#{SecureRandom.base64(4)}")
      }.to_not raise_error
    end
  end

  let(:test_client) { Scale.new(api_key: "test_#{SecureRandom.base64(10)}") }
  let(:live_client) { Scale.new(api_key: "live_#{SecureRandom.base64(10)}") }

  describe '#test?' do
    it 'recognizes test api' do
      expect(test_client.test?).to be true
      expect(test_client.test).to be true
      expect(test_client.test_mode?).to be true

      expect(live_client.test?).to be false
      expect(live_client.test).to be false
      expect(live_client.test_mode?).to be false
    end
  end

  describe '#live?' do
    it 'recognizes live api' do
      expect(test_client.live?).to be false
      expect(test_client.live).to be false
      expect(test_client.live_mode?).to be false

      expect(live_client.live?).to be true
      expect(live_client.live).to be true
      expect(live_client.live_mode?).to be true
    end
  end
end
