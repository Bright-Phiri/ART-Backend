class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_channel"
    NotificationChannel.statistics
  end

  def unsubscribed
    stop_all_streams
  end

  def self.statistics
    data = {res: 'all', lab_orders: LabOrder.statistics, users: User.where.not(role: 'Admin').count, patients: Patient.count,lab_orders_count: LabOrder.active_status.count, results: Result.count}.as_json
    NotificationRelayJob.perform_later(data)
  end
end
