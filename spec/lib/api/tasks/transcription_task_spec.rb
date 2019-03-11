RSpec.describe Scale::Api::Tasks, 'transcription' do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }

  it 'returns transcription for transcription task' do
    response = VCR.use_cassette('transcription') do
      scale.create_transcription_task(
        callback_url: 'http://www.example.com/callback',
        instruction: 'Transcribe the given fields.',
        attachment_type: 'website',
        attachment: 'http://news.ycombinator.com/',
        fields: {
          title: 'Title of Webpage',
          top_result: 'Title of the top result'
        })
    end

    expect(response.type).to eq 'transcription'
    expect(response.response['fields'].keys).to contain_exactly('title', 'top_result')
  end
end
