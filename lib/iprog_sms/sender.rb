# frozen_string_literal: true
# lib/iprog_sms/sender.rb

module IprogSms
  class Sender
    def initialize(api_url)
      @api_url = api_url
      @sms_sender = IprogSms::SMS.new
      @api_client = IprogSms::ApiClient.new(api_url)
    end

    def send_sms_from_api
      sms_details = @api_client.fetch_sms_details
      if sms_details
        @sms_sender.send_sms(sms_details[:phone_number], sms_details[:message])
      else
        puts "Failed to retrieve SMS details from API."
      end
    end
  end
end
