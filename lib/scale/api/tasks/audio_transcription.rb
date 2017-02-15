require 'json'
require 'scale/api/tasks/base_task'

class Scale
  class Api
    class Tasks
      class AudioTranscription < BaseTask
        CREATE_PATH = 'task/audiotranscription'.freeze

        def self.create(callback_url: nil, instruction: nil, attachment_type: 'audio', attachment: nil, verbatim: false, urgency: 'day', metadata: {}, client: nil)
          response = client.post(CREATE_PATH, {
            callback_url: callback_url,
            instruction: instruction,
            attachment_type: attachment_type,
            attachment: attachment,
            verbatim: verbatim,
            urgency: urgency,
            metadata: metadata
          })

          AudioTranscription.new(JSON.parse(response.body))
        end
      end
    end
  end
end