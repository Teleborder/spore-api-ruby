module Spore
  class Client
    module Memberships
      def list_memberships(app_id, env)
        response = get "/apps/#{app_id}/envs/#{env}/memberships"
        response.body["memberships"]
      end

      def grant_membership(app_id, env, email)
        response = post "/apps/#{app_id}/envs/#{env}/memberships", { email: email }
        response.body["membership"]
      end

      def accept_membership(token)
        response = get "/invites/#{token}"
        app_id = response.body["app"]
        env = response.body["environment"]
        email = response.body["email"]
        response = patch "/apps/#{app_id}/envs/#{env}/memberships/#{email}", { token: token }
        response.body["membership"]
      end

      def revoke_membership(app_id, env, email)
        response = delete "/apps/#{app_id}/envs/#{env}/memberships/#{email}"
        response.body["membership"]
      end
    end
  end
end