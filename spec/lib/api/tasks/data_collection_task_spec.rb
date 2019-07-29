RSpec.describe Scale::Api::Tasks, 'data collection' do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }

  it 'returns fields for data collection task' do
    response = VCR.use_cassette('data_collection') do
      scale.create_datacollection_task(
        callback_url: 'http://www.example.com/callback',
        instruction: 'Find the URL for the hiring page for the company with attached website.',
        attachment: 'https://scale.com/',
        attachment_type: 'website',
        fields: {
          hiring_page: 'Hiring Page URL'
        })
    end

    expect(response.type).to eq 'datacollection'
    expect(response.response['fields']['hiring_page']).to eq 'test response'
  end
end
