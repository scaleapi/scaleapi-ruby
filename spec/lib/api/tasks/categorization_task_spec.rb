RSpec.describe Scale::Api::Tasks, 'categorization' do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }

  it 'returns category for categorization task' do
    response = VCR.use_cassette('categorization') do
      scale.create_categorization_task(
        callback_url: 'http://www.example.com/callback',
        instruction: 'Is this company public or private?',
        attachment_type: 'website',
        attachment: 'https://www.google.com',
        categories: %w(public private))
    end

    expect(response.type).to eq 'categorization'
    expect(response.response['category']).to eq 'public'
  end
end
