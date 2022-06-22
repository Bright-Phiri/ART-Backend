class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_channel"
    NotificationChannel.statistics
  end

  def unsubscribed
    stop_all_streams
  end

  def self.statistics
    ActionCable.server.broadcast('notification_channel', {res: 'all',lab_orders: LabOrder.statistics, users: User.where.not(role: 'Admin').count, patients: Patient.count,lab_orders_count: LabOrder.active_status.count, results: Result.count})
  end
end
