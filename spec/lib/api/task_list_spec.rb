RSpec.describe Scale::Api::TaskList do
  let(:scale) { Scale.new(api_key: SCALE_TEST_API_KEY) }

  # the cassette assumes there are totally 3 tasks
  # page 1 retrieves 2 tasks
  let(:page_1) { VCR.use_cassette('task_list_1') { scale.tasks.list(limit: 2) } }
  # page 2 retrieves the remaining 1 task.
  let(:page_2) { VCR.use_cassette('task_list_2') { page_1.next_page } }

  it 'returns a task list' do
    expect(page_1).to be_an_instance_of Scale::Api::TaskList
    expect(page_2).to be_an_instance_of Scale::Api::TaskList

    expect(page_1.length).to eq 2
    expect(page_2.length).to eq 1
  end

  it 'is an enumerable of task' do
    types = page_1.map(&:class).uniq
    expect(types.size).to eq 1
    expect(types.first).to eq Scale::Api::Tasks::BaseTask

    types = page_2.map(&:class).uniq
    expect(types.size).to eq 1
    expect(types.first).to eq Scale::Api::Tasks::BaseTask
  end

  describe '#has_more?' do
    it { expect(page_1.has_more?).to be true }
    it { expect(page_2.has_more?).to be false }
  end

  describe '#page' do
    it { expect(page_1.page).to eq 1 }
    it { expect(page_2.page).to eq 2 }
  end

  describe '#next_page' do
    it 'does not change limit' do
      # page 2 inherits 2 as its limit from page 1
      expect(page_1.limit).to eq 2
      expect(page_2.limit).to eq 2
    end
  end
end
