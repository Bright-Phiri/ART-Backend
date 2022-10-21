class NotificationMessageJob < ApplicationJob
  queue_as :notification_messages

  def perform(phone_number, message)
    TwilioService::SmsCreator.call(phone_number, message)
  end
end
