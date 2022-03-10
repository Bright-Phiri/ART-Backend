class TwilioTextMessenger
    attr_reader :message, :phone_number
  
    def initialize(message, phone_number)
      @message = message
      @phone_number = phone_number
    end
  
    def call
      client = Twilio::REST::Client.new('twilio_account_sid','twilio_account_auth_token')
      client.messages.create({
          from: '',
          to: phone_number,
          body: message
      })
    end
  end