module Spore
  class Client
    module Cells
      def create_cell(app_id, environment, key, value, cell_id = nil)
        cell_id = SecureRandom.uuid if cell_id.nil?
        path = "/apps/#{app_id}/envs/#{environment}/cells"
        response = post path, { id: cell_id, key: key, value: value }
        response.body["cell"]
      end

      def get_cell(app_id, environment, cell_id)
        path = "/apps/#{app_id}/envs/#{environment}/cells/#{cell_id}"
        response = get path
        response.body["cell"]
      end
    end
  end
end