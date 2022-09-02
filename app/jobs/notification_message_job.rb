class NotificationMessageJob < ApplicationJob
  queue_as :notification_messages

  def perform(phone_number, message)
      TwilioSms(phone_number, message).call
  end
end
