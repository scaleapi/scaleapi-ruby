RSpec.describe Scale::Api::Tasks do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }
  let(:original_task) do
    # reuse cassette from categorization_task_spec
    VCR.use_cassette('categorization') do
      scale.create_categorization_task(
        callback_url: 'http://www.example.com/callback',
        instruction: 'Is this company public or private?',
        attachment_type: 'website',
        attachment: 'https://www.google.com',
        categories: %w(public private))
    end
  end

  describe '#find' do
    context 'with valid task id' do
      it 'fetches the same task' do
        retrieved_task = VCR.use_cassette('task_find_valid') do
          scale.tasks.find(original_task.id)
        end

        expect(retrieved_task.id).to eq original_task.id
        expect(retrieved_task.type).to eq original_task.type
        expect(retrieved_task.callback_url).to eq original_task.callback_url
        expect(retrieved_task.instruction).to eq original_task.instruction
        expect(retrieved_task.params).to eq original_task.params
        expect(retrieved_task.metadata).to eq original_task.metadata
        expect(retrieved_task.created_at).to eq original_task.created_at
      end
    end

    context 'with invalid task id' do
      it 'raises error' do
        expect {
          VCR.use_cassette('task_find_invalid') do
            scale.tasks.find('invalid_task_id')
          end
        }.to raise_error Scale::Api::NotFound
      end
    end
  end

  describe '#cancel' do
    context 'with valid task id' do
      it 'cancels the task' do
        canceled_task = VCR.use_cassette('task_cancel_valid') do
          scale.tasks.cancel(original_task.id)
        end

        expect(canceled_task.canceled?).to be true
      end
    end

    context 'with invalid task id' do
      it 'raises error' do
        expect {
          VCR.use_cassette('task_cancel_invalid') do
            scale.tasks.cancel('invalid_task_id')
          end
        }.to raise_error Scale::Api::NotFound
      end
    end
  end
end
