module Spore
  class Client
    module Apps
      def list_apps
        response = get "/apps"
        response.body["apps"]
      end

      def get_app(app_id)
        response = get "/apps/#{app_id}"
        response.body["app"]
      end

      def create_app(app_id = nil, name)
        app_id = SecureRandom.uuid if app_id.nil?
        response = post "/apps", { id: app_id, name: name }, { async: true }
        response.body["app"]
      end

      def change_app_owner(app_id, email)
        response = patch "apps/#{app_id}", { email: email }, { async: true }
        response.body["app"]
      end

      def change_app_name(app_id, name)
        response = patch "apps/#{app_id}", { name: name }
        response.body["app"]
      end
    end
  end
end