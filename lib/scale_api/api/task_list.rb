require 'scale_api/api/tasks/base_task'
require 'scale_api/api/tasks/audio_transcription'
require 'scale_api/api/tasks/datacollection'
require 'scale_api/api/tasks/categorization'
require 'scale_api/api/tasks/comparison'
require 'scale_api/api/tasks/image_recognition'
require 'scale_api/api/tasks/polygonannotation'
require 'scale_api/api/tasks/lineannotation'
require 'scale_api/api/tasks/phone_call'
require 'scale_api/api/tasks/transcription'

class ScaleApi
  class Api
    class TaskList
      include Enumerable
      extend Forwardable
      def_delegators :@docs, :each, :<<, :[], :[]=, :length, :count
      attr_accessor :client, :docs, :limit, :offset, :has_more, :params
      TASK_TYPES_TO_CLASSNAMES = {
        'audiotranscription' => ::ScaleApi::Api::Tasks::AudioTranscription,
        'categorization' => ::ScaleApi::Api::Tasks::Categorization,
        'comparison' => ::ScaleApi::Api::Tasks::Comparison,
        'datacollection' => ::ScaleApi::Api::Tasks::Datacollection,
        'annotation' => ::ScaleApi::Api::Tasks::ImageRecognition,
        'polygonannotation' => ::ScaleApi::Api::Tasks::Polygonannotation,
        'lineannotation' => ::ScaleApi::Api::Tasks::Lineannotation,
        'phonecall' => ::ScaleApi::Api::Tasks::PhoneCall,
        'transcription' => ::ScaleApi::Api::Tasks::Transcription
      }.freeze

      def initialize(client: nil, docs: [], limit: 99, offset: 0, has_more: false, params: {})
        self.client = client
        self.docs = docs.map do |doc|
          ::ScaleApi::Api::Tasks::BaseTask.from_hash(doc.merge('client' => client))
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
        ScaleApi::Api::Tasks.new(client).list(params)
      end

    end
  end
end
