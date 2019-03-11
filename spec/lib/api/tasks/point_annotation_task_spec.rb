RSpec.describe Scale::Api::Tasks, 'point annotation' do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }

  it 'returns annotations for point annotation task' do
    response = VCR.use_cassette('point_annotation') do
      scale.create_pointannotation_task(
        callback_url: 'http://www.example.com/callback',
        instruction: 'Draw a point on every **headlight** and **brakelight** of a car in the image.',
        attachment_type: 'image',
        attachment: 'http://i.imgur.com/XOJbalC.jpg',
        objects_to_annotate: ['headlight', 'brakelight'],
        with_labels: true)
    end

    expect(response.type).to eq 'pointannotation'
  end
end
