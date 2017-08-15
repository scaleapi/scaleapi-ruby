require 'json'
require 'scale/api/tasks/base_task'

class Scale
  class Api
    class Tasks
      class Transcription < BaseTask
        CREATE_PATH = 'task/transcription'.freeze

        def self.create(callback_url: nil, instruction: nil, attachment_type: nil, choices: {}, attachment: null, fields: {}, urgency: 'day', metadata: {}, client: nil, repeatable_fields: nil)
          args = {
            callback_url: callback_url,
            instruction: instruction,
            attachment_type: attachment_type,
            attachment: attachment,
            fields: fields,
            choices: choices,
            urgency: urgency,
            metadata: metadata
          }
          if repeatable_fields != nil
            args['repeatable_fields'] = repeatable_fields
          end
          response = client.post(CREATE_PATH, args)
          Transcription.new(JSON.parse(response.body))
        end
      end
    end
  end
end