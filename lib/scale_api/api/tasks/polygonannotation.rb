require 'json'
require 'scale_api/api/tasks/base_task'

class ScaleApi
  class Api
    class Tasks
      class Polygonannotation < ScaleApi::Api::Tasks::BaseTask
        CREATE_PATH = 'task/polygonannotation'.freeze

        def self.create(callback_url: nil, instruction: nil, attachment_type: nil, attachment: null, objects_to_annotate: [], with_labels: false, examples: [], urgency: 'day', metadata: {}, client: nil)
          response = client.post(CREATE_PATH, {
            callback_url: callback_url,
            instruction: instruction,
            attachment_type: attachment_type,
            attachment: attachment,
            objects_to_annotate: objects_to_annotate,
            with_labels: with_labels,
            examples: examples,
            urgency: urgency,
            metadata: metadata
          })

          Polygonannotation.new(JSON.parse(response.body))
        end
      end
    end
  end
end
