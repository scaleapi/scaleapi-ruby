require 'json'
require 'scale/api/tasks/base_task'

class Scale
  class Api
    class Tasks
      class Comparison < BaseTask
        CREATE_PATH = 'task/comparison'.freeze

        def self.create(callback_url: nil, instruction: nil, attachment_type: nil, attachments: [], fields: {}, urgency: 'day', choices: {}, metadata: {}, client: nil)
          response = client.post(CREATE_PATH, {
            callback_url: callback_url,
            instruction: instruction,
            attachment_type: attachment_type,
            attachments: attachments,
            fields: fields,
            choices: choices,
            urgency: urgency,
            metadata: metadata
          })

          Comparison.new(JSON.parse(response.body))
        end
      end
    end
  end
end