require 'json'
require 'scale/api/tasks/base_task'

class Scale
  class Api
    class Tasks
      class Segmentannotation < Scale::Api::Tasks::BaseTask
        CREATE_PATH = 'task/segmentannotation'.freeze

        def self.create(callback_url: nil, instruction: nil, attachment_type: nil, attachment: null, labels: [], allow_unlabeled: false, layers: nil, examples: [], urgency: 'day', metadata: {}, client: nil)
          response = client.post(CREATE_PATH, {
            callback_url: callback_url,
            instruction: instruction,
            attachment_type: attachment_type,
            attachment: attachment,
            labels: labels,
            allow_unlabeled: allow_unlabeled,
            urgency: urgency,
            metadata: metadata
          })

          Segmentannotation.new(JSON.parse(response.body))
        end
      end
    end
  end
end
