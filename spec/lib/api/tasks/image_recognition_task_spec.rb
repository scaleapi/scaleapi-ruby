RSpec.describe Scale::Api::Tasks, 'image recognition' do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }

  it 'returns annotations for image recognition task' do
    response = VCR.use_cassette('image_recognition') do
      scale.create_annotation_task(
        callback_url: 'http://www.example.com/callback',
        instruction: 'Draw a box around each **baby cow** and **big cow**',
        attachment_type: 'image',
        attachment: 'http://i.imgur.com/v4cBreD.jpg',
        objects_to_annotate: ['baby cow', 'big cow'],
        with_labels: true,
        examples: [
          {
            correct: true,
            image: 'http://i.imgur.com/lj6e98s.jpg',
            explanation: 'The boxes are tight and accurate'
          },
          {
            correct: false,
            image: 'http://i.imgur.com/HIrvIDq.jpg',
            explanation: 'The boxes are neither accurate nor complete'
          }
        ])
    end

    expect(response.type).to eq 'annotation'
    response.response['annotations'].each do |annotation|
      expect(annotation.keys).to contain_exactly('left', 'top', 'width', 'height', 'label')
    end
  end
end
