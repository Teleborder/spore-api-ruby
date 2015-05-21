module Spore
  class Client
    module Users
      def signup(email, password)
        response = post "/users", { email: email, password: password }
        @verified = response.body["user"]["verified"]
        login(email, password)
      end

      def login(email, password)
        response = post "/users/#{email}/keys", { password: password }
        @email = email
        @key = response.body["key"]
      end

      def verify(token)
        response = patch "/users/#{@email}", { token: token }
      end

      def signed_in?
        !email.nil? && !key.nil?
      end
    end
  end
end