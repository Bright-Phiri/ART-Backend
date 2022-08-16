class TwilioSms < ApplicationService
    attr_reader :phone_number, :message

    def initialize(phone_number, message)
      @phone_number = phone_number
      @message = message
    end

    def call
      twilio_client = Twilio::REST::Client.new Rails.application.credentials.twilio_sid, Rails.application.credentials.twilio_token
      twilio_client.api.account.messages.create(
      from: Rails.application.credentials.twilio_phone_number,
      to: phone_number, 
      body: message
      )
    end
  end