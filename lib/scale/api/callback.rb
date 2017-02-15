class Scale
  class Api
    class Callback
      attr_reader :client, :response, :task, :task_id

      def initialize(params, callback_key: nil, client: nil)
        @response = params[:response]
        @task = BaseTask.from_hash(params[:task].merge('client': client))
      end

      def verified?
        Callback.valid_callback_auth_key?(request_callback_key, client.callback_auth_key)
      end

      def self.valid_callback_auth_key?(callback_key, request_callback_key)
        callback_key && request_callback_key && request_callback_key == callback_key
      end
    end
  end
end

require 'scale/api/tasks'
require 'scale/api/tasks/base_task'