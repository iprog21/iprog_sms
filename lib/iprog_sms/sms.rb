# frozen_string_literal: true
# lib/iprog_sms/sms.rb

require 'rubyserial'

module IprogSms
  class SMS
    attr_reader :error_message

    def initialize(port_str = "/dev/ttyUSB0")
      @baud_rate = 9600
      @port_str = port_str  # Use the passed port, or default to "/dev/ttyUSB0"
      @error_message = nil   # Initialize error message
    end

    def send_sms(phone_number, message)
      @error_message = nil   # Reset error message before sending

      if connected?
        begin
          # Open the serial connection
          serial = Serial.new(@port_str, @baud_rate)
          result_status = false

          # Set SMS to text mode with a shorter delay
          send_at_command(serial, "AT+CMGF=1", 3)

          # Specify the recipient phone number
          response = send_at_command(serial, "AT+CMGS=\"#{phone_number}\"", 3)
          unless response.include?(">")
            @error_message = "Failed to specify recipient. Response: #{response}"
            result_status  = false
          end

          # Send the actual SMS message, followed by Ctrl+Z (ASCII 26)
          response = send_at_command(serial, "#{message}\x1A", 5)
          if response.include?("+CMGS")
            puts "SMS successfully sent to #{phone_number}."
            result_status = true
          elsif response.include?("+CMS ERROR")
            error_code = response.match(/\+CMS ERROR: (\d+)/)[1]
            @error_message = "Failed to send SMS. Error code: #{error_code}"
            result_status  = false
          else
            @error_message = "Unexpected response while sending SMS: #{response}"
            result_status  = false
          end

          serial.close

          result_status
        rescue StandardError => e
          @error_message = "Error while sending SMS: #{e.message}"
          false
        end
      else
        @error_message = "SIM800C is not connected!"
        false
      end
    end

    def connected?
      begin
        serial = Serial.new(@port_str, @baud_rate)
        response = send_at_command(serial, "AT")
        serial.close
        response.include?("OK") # Check if the response contains "OK"
      rescue StandardError => e
        @error_message = "Error checking connection: #{e.message}"
        false
      end
    end

    private

    def send_at_command(serial, command, wait_time = 1)
      puts "Sending command: #{command}"
      serial.write("#{command}\r")
      sleep(wait_time)
      response = serial.read(1000)
      puts "Response: #{response}"
      response
    rescue StandardError => e
      @error_message = "Error during command execution: #{e.message}"
      ""
    end
  end
end
