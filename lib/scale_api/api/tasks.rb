class ScaleApi
  class Api
    class Tasks < Struct.new(:client)
      def list(start_time: nil, end_time: nil, limit: 99, offset: 0, type: nil, status: nil)
        params = {
          start_time: start_time ? start_time.iso8601 : nil,
          end_time: end_time ? end_time.iso8601 : nil,
          limit: limit,
          offset: offset,
          status: status,
          type: type
        }

        response = client.get('tasks', params)
        body = JSON.parse(response.body)

        TaskList.new({
          client: client,
          docs: body['docs'],
          limit: body['limit'],
          offset: body['offset'],
          has_more: body['has_more'],
          params: params
        })
      end
      
      def find(task_id)
        response = client.get("task/#{task_id}")
        BaseTask.from_hash(JSON.parse(response.body).merge('client' => client))
      end

      def cancel(task_id)
        response = client.post("task/#{task_id}/cancel")
        BaseTask.from_hash(JSON.parse(response.body).merge('client' => client))
      end

      def create(args = {})
        raise ArgumentError.new('Task type is required') if (args[:type].nil? && args['type'].nil?)
        klass = ::ScaleApi::Api::TaskList::TASK_TYPES_TO_CLASSNAMES[(args[:type] || args['type']).to_s]
        
        unless klass
          raise ArgumentError.new('Unsupported task type. Supported task types: ' + ::ScaleApi::Api::TaskList::TASK_TYPES_TO_CLASSNAMES.keys.join(','))
        end

        args.delete(:type)
        klass.create(args.merge(client: client))
      end

      alias_method :all, :list
      alias_method :where, :list
    end
  end
end

require 'scale_api/api/task_list'
