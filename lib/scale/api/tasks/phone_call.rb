require 'json'
require 'scale/api/tasks/base_task'

class Scale
  class Api
    class Tasks
      class PhoneCall < Scale::Api::Tasks::BaseTask
        CREATE_PATH = 'task/phonecall'.freeze

        def self.create(callback_url: nil, instruction: nil, phone_number: nil, script: nil, entity_name: nil, attachment: nil, attachment_type: nil, fields: {}, choices: {}, urgency: 'day', metadata: {}, client: nil)
          message = 'Phone call tasks have been deprecated and are no longer available.'
          pp message
          raise ScaleApi::Api::BadRequest.new(message)
        end
      end
    end
  end
end