class TwilioTextMessenger
    attr_reader :message, :phone_number
  
    def initialize(message, phone_number)
      @message = message
      @phone_number = phone_number
    end
  
    def call
      client = Twilio::REST::Client.new(Rails.application.credentials.sid,Rails.application.credentials.auth)
      client.messages.create({
          from: Rails.application.credentials.phone_number,
          to: phone_number,
          body: message
      })
    end
  end