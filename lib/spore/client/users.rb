module Spore
  class Client

    module Users

      def signup(email, password)
        response = post '/users', { email: email, password: password }
        body = response[:body]

        data = body[:json][:user]
      end

      def login(email, password)
      end

      def verify(token)
      end
    end
  end
end