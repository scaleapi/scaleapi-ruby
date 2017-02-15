require 'json'
require 'scale/api/tasks/base_task'

class Scale
  class Api
    class Tasks
      class Categorization < BaseTask
        CREATE_PATH = 'task/categorize'.freeze

        def self.create(callback_url: nil, instruction: nil, attachment_type: nil, attachment: nil, categories: [], urgency: 'day', category_ids: {}, allow_multiple: false, metadata: {}, client: nil)
          body = {
            callback_url: callback_url,
            instruction: instruction,
            attachment_type: attachment_type,
            attachment: attachment,
            categories: categories,
            urgency: urgency,
            category_ids: category_ids,
            allow_multiple: allow_multiple,
            metadata: metadata
          }

          body.delete(:category_ids) if category_ids.keys.count.zero?
          body.delete(:categories) if categories.count.zero?

          response = client.post(CREATE_PATH, body)
          Categorization.new(JSON.parse(response.body))
        end
      end
    end
  end
end