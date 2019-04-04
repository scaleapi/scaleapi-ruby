RSpec.describe Scale::Api::Tasks, 'comparison' do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }

  it 'returns choice for comparison task' do
    response = VCR.use_cassette('comparison') do
      scale.create_comparison_task(
        callback_url: 'http://www.example.com/callback',
        instruction: 'Do the objects in these images have the same pattern?',
        attachments: [
          'http://i.ebayimg.com/00/$T2eC16dHJGwFFZKjy5ZjBRfNyMC4Ig~~_32.JPG',
          'http://images.wisegeek.com/checkered-tablecloth.jpg'
        ],
        attachment_type: 'image',
        choices: %w(yes no))
    end

    expect(response.type).to eq 'comparison'
    expect(response.response['choice']).to eq 'yes'
  end
end
