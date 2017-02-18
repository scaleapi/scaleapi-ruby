require 'time'

class Scale
  class Api
    class Tasks
      class BaseTask
        attr_accessor :client
        ATTRIBUTES = %w(task_id type instruction params urgency response callback_url created_at status completed_at callback_succeeded_at metadata).freeze
        ATTRIBUTES.each { |attr| attr_reader attr }

        alias_method :id, :task_id

        def self.from_hash(hash)
          klass = ::Scale::Api::TaskList::TASK_TYPES_TO_CLASSNAMES[(hash[:type] || hash['type']).to_s] || self
          klass.new(hash)
        end

        def cancel!
          Tasks.new(client).cancel(id)
        end

        def initialize(json = {})

          ATTRIBUTES.each do |attr|
            instance_variable_set "@#{attr}", json[attr]
          end

          @client = (json[:client] || json['client'])

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

        protected

        def tweak_attributes
          @created_at = Time.parse(created_at) rescue nil
          @completed_at = Time.parse(completed_at) rescue nil
        end

      end
    end
  end
end
