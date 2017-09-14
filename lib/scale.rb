class Scale
  attr_accessor :api_key, :callback_auth_key, :default_request_params, :logging

  VALID_TASK_TYPES = [
    "datacollection".freeze,
    "categorization".freeze,
    "comparison".freeze,
    "annotation".freeze,
    "polygonannotation".freeze,
    "lineannotation".freeze,
    "transcription".freeze,
    "audiotranscription".freeze,
    "pointannotation".freeze,
    "segmentannotation".freeze
  ]

  def method_missing(methodId, *args, &block)
    str = methodId.id2name
    match = /^create_([a-z_]+)_task$/.match(str)
    if match
      taskType = match[1].gsub(/[^a-z]/, '')
      if taskType == "imagerecognition"
        taskType = "annotation"
      end
      if VALID_TASK_TYPES.include?(taskType)
        create_task(match[1], *args)
      else
        raise ArgumentError.new("Method `#{methodId}` doesn't exist.")
      end
    else
      raise ArgumentError.new("Method `#{methodId}` doesn't exist.")
    end
  end

  def self.validate_api_key(api_key)
    if api_key.length < 5 || !(api_key.start_with?('live') || api_key.start_with?('test')) 
      raise Api::APIKeyInvalid
    end
  end

  def initialize(api_key: nil, callback_auth_key: nil, default_request_params: {}, logging: false, callback_url: nil)
    Scale.validate_api_key(api_key)

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
    @tasks ||= Scale::Api::Tasks.new(client)
  end

  def create_task(type, args = {})
    createPath = 'task/' + type
    response = client.post(createPath, args)
    Api::Tasks::BaseTask.new(JSON.parse(response.body))
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
end

require 'scale/api'
require 'scale/api/errors'
require 'scale/api/callback'
require 'scale/api/tasks'
require 'scale/api/tasks/base_task'
require 'json'
require 'scale/api/task_list'
