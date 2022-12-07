# frozen_string_literal: true

class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_channel"
  end

  def unsubscribed
    stop_all_streams
  end

  on_subscribe do
    NotificationRelayJob.perform_later
  end
end
