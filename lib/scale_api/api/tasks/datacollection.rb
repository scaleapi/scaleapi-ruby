require 'json'
require 'scale_api/api/tasks/base_task'

class ScaleApi
  class Api
    class Tasks
      class Datacollection < BaseTask
        CREATE_PATH = 'task/datacollection'.freeze

        def self.create(callback_url: nil, instruction: nil, attachment_type: nil, attachment: null, fields: {}, urgency: 'day', metadata: {}, client: nil)
          response = client.post(CREATE_PATH, {
            callback_url: callback_url,
            instruction: instruction,
            attachment_type: attachment_type,
            attachment: attachment,
            fields: fields,
            urgency: urgency,
            metadata: metadata
          })

          Datacollection.new(JSON.parse(response.body))
        end
      end
    end
  end
end
