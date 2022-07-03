class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "dashboard_channel"
    DashboardChannel.statistics
  end

  def unsubscribed
    stop_all_streams
  end

  def self.statistics
    data = {res: 'all', lab_orders: LabOrder.statistics, users: User.where(role: 'Admin').invert_where.count, patients: Patient.count,lab_orders_count: LabOrder.active_status.count, results: Result.count}.as_json
    DashboardSocketDataJob.perform_later(data)
  end
end
