require 'json'
require 'scale_api/api/tasks/base_task'

class ScaleApi
  class Api
    class Tasks
      class ImageRecognition < ScaleApi::Api::Tasks::BaseTask
        CREATE_PATH = 'task/annotation'.freeze

        def self.create(callback_url: nil, instruction: nil, attachment_type: nil, attachment: null, objects_to_annotate: [], with_labels: false, min_width: nil, min_height: nil, examples: [], urgency: 'day', metadata: {}, client: nil)
          response = client.post(CREATE_PATH, {
            callback_url: callback_url,
            instruction: instruction,
            attachment_type: attachment_type,
            attachment: attachment,
            objects_to_annotate: objects_to_annotate,
            with_labels: with_labels,
            min_width: min_width,
            min_height: min_height,
            examples: examples,
            urgency: urgency,
            metadata: metadata
          })

          ImageRecognition.new(JSON.parse(response.body))
        end
      end
    end
  end
end
