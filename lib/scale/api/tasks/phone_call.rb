require 'json'
require 'scale/api/tasks/base_task'

class Scale
  class Api
    class Tasks
      class PhoneCall < Scale::Api::Tasks::BaseTask
        CREATE_PATH = 'task/phonecall'.freeze

        def self.create(callback_url: nil, instruction: nil, phone_number: nil, script: nil, entity_name: nil, attachment: nil, attachment_type: nil, fields: {}, choices: {}, urgency: 'day', metadata: {}, client: nil)
          response = client.post(CREATE_PATH, {
            callback_url: callback_url,
            instruction: instruction,
            attachment_type: attachment_type,
            attachment: attachment,
            phone_number: phone_number,
            script: script,
            entity_name: entity_name,
            fields: fields,
            choices: choices,
            urgency: urgency,
            metadata: metadata
          })

          PhoneCall.new(JSON.parse(response.body))
        end
      end
    end
  end
end