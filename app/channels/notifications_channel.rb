class NotificationsChannel < ApplicationCable::Channel
  def subscribed
      stream_from "notifications_channel"
      NotificationsChannel.unverified_lab_orders
  end

  def unsubscribed
    stop_all_streams
  end

  def self.unverified_lab_orders
    data = {unverified_lab_orders_count: LabOrder.unverified_lab_orders.count}.as_json
    NotificationRelayJob.perform_later(data)
  end

end
