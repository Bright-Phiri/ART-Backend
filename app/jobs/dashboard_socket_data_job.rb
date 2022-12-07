class DashboardSocketDataJob < ApplicationJob
  queue_as :default

  def perform(res)
    data = { res: res, lab_orders: LabOrder.statistics, users: User.where(role: 'Admin').invert_where.count, patients: Patient.count, lab_orders_count: LabOrder.count, results: Result.count }.as_json
    ActionCable.server.broadcast('dashboard_channel', data)
  end
end
