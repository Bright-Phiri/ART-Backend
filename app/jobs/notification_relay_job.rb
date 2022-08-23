class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform(data)
    ActionCable.server.broadcast('notifications_channel', data)
  end
end
