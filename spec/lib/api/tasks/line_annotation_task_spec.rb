RSpec.describe Scale::Api::Tasks, 'line annotation' do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }

  it 'returns annotations for line lineannotation task' do
    response = VCR.use_cassette('line_annotation') do
      scale.create_lineannotation_task(
        callback_url: 'http://www.example.com/callback',
        instruction: 'Draw a tight shape around the big cow',
        attachment_type: 'image',
        attachment: 'http://i.imgur.com/v4cBreD.jpg',
        objects_to_annotate: ['big cow'],
        with_labels: true)
    end

    expect(response.type).to eq 'lineannotation'
    response.response['annotations'].each do |annotation|
      expect(annotation.keys).to contain_exactly('vertices', "label")
    end
  end
end
