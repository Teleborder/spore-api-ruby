module Spore
  class Client
    module Deployments
      def list_deployments(app_id, env)
        response = get "/apps/#{app_id}/envs/#{env}/deployments"
        response.body["deployments"]
      end

      def create_deployment(app_id, env, name)
        response = post "/apps/#{app_id}/envs/#{env}/deployments", { name: name }
        response.body["deployment"]
      end

      def destroy_deployment(app_id, env, name)
        response = delete "/apps/#{app_id}/envs/#{env}/deployments/#{name}"
        response.body["deployment"]
      end
    end
  end
end