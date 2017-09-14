require 'time'

class Scale
  class Api
    class Tasks
      class BaseTask
        def method_missing(methodId, *args, &block)
          str = methodId.id2name
          value = @data[str]
          if value
            value
          else
            raise ArgumentError.new("Method `#{methodId}` doesn't exist.")
          end
        end

        def self.from_hash(hash)
          klass = self
          klass.new(hash)
        end

        def cancel!
          Tasks.new(client).cancel(id)
        end

        def initialize(json = {})
          @client = json.delete(:client) || json.delete('client')
          @data = json

          tweak_attributes
        end

        def day?
          urgency == 'day'
        end

        def week?
          urgency == 'week'
        end

        def immediate?
          urgency == 'immediate'
        end

        def pending?
          status == 'pending'
        end

        def completed?
          status == 'completed'
        end

        def canceled?
          status == 'canceled'
        end

        def callback_succeeded?
          !!callback_succeeded_at
        end

        def id
          task_id
        end

        def raw_json
          @data
        end

        protected

        def tweak_attributes
          @created_at = Time.parse(created_at) rescue nil
          @completed_at = Time.parse(completed_at) rescue nil
        end

      end
    end
  end
end
