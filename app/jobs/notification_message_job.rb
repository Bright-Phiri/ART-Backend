class NotificationMessageJob < ApplicationJob
  queue_as :notification_messages

  def perform(phone_number, message)
      TwilioSms.call(phone_number, message)
  end
end
