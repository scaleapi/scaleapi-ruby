require 'scale/api/tasks/base_task'
require 'scale/api/tasks/audio_transcription'
require 'scale/api/tasks/datacollection'
require 'scale/api/tasks/categorization'
require 'scale/api/tasks/comparison'
require 'scale/api/tasks/image_recognition'
require 'scale/api/tasks/phone_call'
require 'scale/api/tasks/transcription'

class Scale
  class Api
    class TaskList
      include Enumerable
      extend Forwardable
      def_delegators :@docs, :each, :<<, :[], :[]=
      attr_accessor :client, :docs, :count, :limit, :offset, :has_more, :params
      alias_method :length, :count
      TASK_TYPES_TO_CLASSNAMES = {
        'audiotranscription': ::Scale::Api::Tasks::AudioTranscription,
        'categorization': ::Scale::Api::Tasks::Categorization,
        'comparison': ::Scale::Api::Tasks::Comparison,
        'datacollection': ::Scale::Api::Tasks::Datacollection,
        'annotation': ::Scale::Api::Tasks::ImageRecognition,
        'phonecall': ::Scale::Api::Tasks::PhoneCall,
        'transcription': ::Scale::Api::Tasks::Transcription
      }.freeze

      def initialize(client: nil, docs: [], limit: 99, offset: 0, has_more: false, params: {})
        self.client = client
        self.docs = docs.map do |doc|
          ::Scale::Api::Tasks::BaseTask.from_hash(doc.merge('client': client))
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