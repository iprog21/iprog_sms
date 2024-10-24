# frozen_string_literal: true
# lib/iprog_sms/api_client.rb

require 'net/http'
require 'json'

module IprogSms
  class ApiClient
    def initialize(api_url)
      @api_url = api_url
    end

    def fetch_sms_details
      uri = URI(@api_url)
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      { phone_number: data['phone_number'], message: data['message'] }
    rescue StandardError => e
      puts "Error fetching data from API: #{e.message}"
      nil
    end
  end
end
