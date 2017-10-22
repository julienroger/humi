module Humi
  class Client
    module Users
      def get_self(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}

        get("api/v1/user", options)
      end

      def list_users
        #
      end

      def get_user(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        id      = args.first || "me"

        get("api/v1/users/#{id}", options)
      end

      def update_user
        #
      end
    end
  end
end
