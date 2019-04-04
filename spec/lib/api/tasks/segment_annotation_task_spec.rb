RSpec.describe Scale::Api::Tasks, 'segment annotation' do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }

  it 'returns annotations for segment annotation task' do
    response = VCR.use_cassette('segment_annotation') do
      scale.create_segmentannotation_task({
        callback_url: 'http://www.example.com/callback',
        instruction: 'Please segment the image using the given labels.',
        attachment_type: 'image',
        attachment: 'http://i.imgur.com/XOJbalC.jpg',
        labels: ['background', 'road', 'vegetation', 'lane marking'],
        instance_labels: ['vehicle', 'pedestrian'],
        allow_unlabeled: false})
    end

    expect(response.type).to eq 'segmentannotation'
    expect(response.response['annotations'].keys)
        .to contain_exactly('unlabeled', 'labeled', 'combined')
    expect(response.response['labelMapping'].keys)
        .to contain_exactly('background', 'road', 'vegetation', 'lane marking')
  end
end
