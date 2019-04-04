RSpec.describe Scale::Api::Tasks, 'audio transcription' do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }

  it 'returns transcription for audio transcription task' do
    response = VCR.use_cassette('audio_transcription') do
      scale.create_audiotranscription_task(
        callback_url: 'http://www.example.com/callback',
        attachment_type: 'audio',
        attachment: 'https://storage.googleapis.com/deepmind-media/pixie/knowing-what-to-say/second-list/speaker-3.wav',
        verbatim: false)
    end

    expect(response.type).to eq 'audiotranscription'
    expect(response.response.keys).to contain_exactly('transcript', 'duration', 'alignment')
  end
end
