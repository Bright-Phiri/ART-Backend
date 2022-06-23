class DashboardSocketDataJob < ApplicationJob
  queue_as :default

  def perform(data)
    ActionCable.server.broadcast('dashboard_channel', data)
  end
end
