require 'scale/api/tasks/base_task'

class Scale
  class Api
    class TaskList
      include Enumerable
      extend Forwardable
      def_delegators :@docs, :each, :<<, :[], :[]=, :length, :count
      attr_accessor :client, :docs, :limit, :offset, :has_more, :params
      TASK_TYPES_TO_CLASSNAMES = {
        'audiotranscription' => ::Scale::Api::Tasks::BaseTask,
        'categorization' => ::Scale::Api::Tasks::BaseTask,
        'comparison' => ::Scale::Api::Tasks::BaseTask,
        'datacollection' => ::Scale::Api::Tasks::BaseTask,
        'annotation' => ::Scale::Api::Tasks::BaseTask,
        'polygonannotation' => ::Scale::Api::Tasks::BaseTask,
        'lineannotation' => ::Scale::Api::Tasks::BaseTask,
        'phonecall' => ::Scale::Api::Tasks::BaseTask,
        'transcription' => ::Scale::Api::Tasks::BaseTask,
        'pointannotation' => ::Scale::Api::Tasks::BaseTask,
        'segmentannotation' => ::Scale::Api::Tasks::BaseTask
      }.freeze

      def initialize(client: nil, docs: [], limit: 99, offset: 0, has_more: false, params: {})
        self.client = client
        self.docs = docs.map do |doc|
          ::Scale::Api::Tasks::BaseTask.from_hash(doc.merge('client' => client))
        end

        self.limit = limit
        self.offset = offset
        self.has_more = has_more
        self.params = params # Used to get next page
      end

      def has_more?
        !!has_more
      end

      def page
        (offset + (limit * 1)) / limit
      end

      def next_page
        next_page_params = params.dup
        params[:offset] = params[:limit] + params[:offset]
        Scale::Api::Tasks.new(client).list(params)
      end

    end
  end
end