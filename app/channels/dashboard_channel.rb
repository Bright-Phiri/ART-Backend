# frozen_string_literal: true

class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "dashboard_channel"
  end

  def unsubscribed
    stop_all_streams
  end

  on_subscribe do
    DashboardSocketDataJob.perform_later('all')
  end
end
