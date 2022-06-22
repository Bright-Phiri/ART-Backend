class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform(data)
    ActionCable.server.broadcast('notification_channel', data)
  end
end
