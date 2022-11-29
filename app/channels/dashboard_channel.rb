class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "dashboard_channel"
  end

  def unsubscribed
    stop_all_streams
  end

  on_subscribe do
    data = {res: 'all', lab_orders: LabOrder.unscoped.statistics, users: User.where(role: 'Admin').invert_where.count, patients: Patient.count, lab_orders_count: LabOrder.count, results: Result.count}
    DashboardSocketDataJob.perform_later(data)
  end
end
