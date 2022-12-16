# frozen_string_literal: true

class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform
    data = { unverified_lab_orders_count: LabOrder.unverified_lab_orders.count }.as_json
    ActionCable.server.broadcast('notifications_channel', data)
  end
end
