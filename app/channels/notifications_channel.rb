class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_channel"
  end

  def unsubscribed
    stop_all_streams
  end

  on_subscribe do
    data = {unverified_lab_orders_count: LabOrder.unverified_lab_orders.count}
    NotificationRelayJob.perform_later(data)
  end
end
