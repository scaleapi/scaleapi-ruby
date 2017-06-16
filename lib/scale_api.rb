class ScaleApi
  attr_accessor :api_key, :callback_auth_key, :default_request_params, :logging

  def self.validate_api_key(api_key)
    if api_key.length < 5 || !(api_key.start_with?('live') || api_key.start_with?('test')) 
      raise Api::APIKeyInvalid
    end
  end

  def initialize(api_key: nil, callback_auth_key: nil, default_request_params: {}, logging: false, callback_url: nil)
    ScaleApi.validate_api_key(api_key)

    self.api_key = api_key
    self.callback_auth_key = callback_auth_key
    self.default_request_params = default_request_params.merge(callback_url: callback_url)
    self.logging = logging
  end

  def live?
    api_key.start_with?('live')
  end

  def test?
    api_key.start_with?('test')
  end

  def client
    @client ||= Api.new(api_key, callback_auth_key, default_request_params, logging)
  end

  def tasks
    @tasks ||= ScaleApi::Api::Tasks.new(client)
  end

  def create_datacollection_task(args = {})
    Api::Tasks::Datacollection.create(args.merge(client: client))
  end

  def create_categorization_task(args = {})
    Api::Tasks::Categorization.create(args.merge(client: client))
  end

  def create_comparison_task(args = {})
    Api::Tasks::Comparison.create(args.merge(client: client))
  end

  def create_image_recognition_task(args = {})
    Api::Tasks::ImageRecognition.create(args.merge(client: client))
  end

  def create_polygonannotation_task(args = {})
    Api::Tasks::Polygonannotation.create(args.merge(client: client))
  end

  def create_lineannotation_task(args = {})
    Api::Tasks::Lineannotation.create(args.merge(client: client))
  end

  def create_phone_call_task(args = {})
    Api::Tasks::PhoneCall.create(args.merge(client: client))
  end

  def create_transcription_task(args = {})
    Api::Tasks::Transcription.create(args.merge(client: client))
  end

  def create_audio_transcription_task(args = {})
    Api::Tasks::AudioTranscription.create(args.merge(client: client))
  end

  def build_callback(params, callback_key: nil)
    callback = Api::Callback.new(params, callback_key: callback_key, client: client)
    
    if block_given?
      yield callback
    else 
      callback
    end
  end

  alias_method :live, :live?
  alias_method :test, :test?
  alias_method :live_mode?, :live?
  alias_method :test_mode?, :test?
  alias_method :create_annotation_task, :create_image_recognition_task
  alias_method :create_phonecall_task, :create_phone_call_task
  alias_method :create_audiotranscription_task, :create_audio_transcription_task
end

require 'scale_api/api'
require 'scale_api/api/errors'
require 'scale_api/api/callback'
require 'scale_api/api/tasks'
require 'scale_api/api/tasks/audio_transcription'
require 'scale_api/api/tasks/base_task'
require 'scale_api/api/tasks/datacollection'
require 'scale_api/api/tasks/categorization'
require 'scale_api/api/tasks/comparison'
require 'scale_api/api/tasks/image_recognition'
require 'scale_api/api/tasks/polygonannotation'
require 'scale_api/api/tasks/lineannotation'
require 'scale_api/api/tasks/phone_call'
require 'scale_api/api/tasks/transcription'
require 'scale_api/api/task_list'
