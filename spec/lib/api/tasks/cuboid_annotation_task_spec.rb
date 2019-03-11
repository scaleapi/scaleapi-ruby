RSpec.describe Scale::Api::Tasks, 'cuboid annotation' do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }

  it 'returns annotations for line cuboid annotation task' do
    response = VCR.use_cassette('cuboid_annotation') do
      scale.create_cuboidannotation_task({
        callback_url: 'http://www.example.com/callback',
        instruction: 'Draw a cuboid around each car or truck.',
        attachment_type: 'image',
        attachment: 'http://i.imgur.com/v4cBreD.jpg',
        objects_to_annotate: ['car', 'truck']})
    end

    expect(response.type).to eq 'cuboidannotation'
    response.response['annotations'].each do |annotation|
      expect(annotation.keys).to contain_exactly('vertices', "label")
    end
  end
end
