class DashboardChannel < ApplicationCable::Channel
  def subscribed
      stream_from "dashboard_channel"
      statistics
  end

  def unsubscribed
      stop_all_streams
  end

  def statistics
      data = {res: 'all', lab_orders: LabOrder.unscoped.statistics, users: User.where(role: 'Admin').invert_where.count, patients: Patient.count, lab_orders_count: LabOrder.count, results: Result.count}.as_json
      DashboardSocketDataJob.perform_later(data)
  end
end
