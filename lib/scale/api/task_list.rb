require 'scale/api/tasks/base_task'

class Scale
  class Api
    class TaskList
      include Enumerable
      extend Forwardable
      def_delegators :@docs, :each, :<<, :[], :[]=, :length, :count
      attr_accessor :client, :docs, :limit, :offset, :has_more, :params

      def initialize(client: nil, docs: [], limit: 99, offset: 0, has_more: false, params: {})
        self.client = client
        self.docs = docs.map do |doc|
          ::Scale::Api::Tasks::BaseTask.new(doc, client)
        end

        self.limit = limit
        self.offset = offset
        self.has_more = has_more
        self.params = params # Used to get next page
      end

      def has_more?
        !!has_more
      end

      def page
        (offset + limit) / limit
      end

      def next_page
        params[:offset] = params[:limit] + params[:offset]
        Scale::Api::Tasks.new(client).list(params)
      end

    end
  end
end