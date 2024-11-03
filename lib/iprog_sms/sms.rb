# frozen_string_literal: true
# lib/iprog_sms/sms.rb

require 'rubyserial'

module IprogSms
  class SMS
    def initialize(port_str = "/dev/ttyUSB0")
      @baud_rate = 9600
      @port_str = port_str  # Use the passed port, or default to "/dev/ttyUSB0"
    end

    def send_sms(phone_number, message)
      if connected?
        begin
          # Open the serial connection
          serial = Serial.new(@port_str, @baud_rate)

          # Set SMS to text mode with a shorter delay
          send_at_command(serial, "AT+CMGF=1", 1)

          # Specify the recipient phone number with a shorter delay
          send_at_command(serial, "AT+CMGS=\"#{phone_number}\"", 1)

          # Send the actual SMS message, followed by Ctrl+Z (ASCII 26), with a longer delay for processing
          send_at_command(serial, "#{message}\x1A", 3)

          puts "SMS sent to #{phone_number}."
          serial.close
        rescue Exception => e
          puts "Error: #{e.message}"
        end
      else
        puts "SIM800C is not connected!"
      end
    end

    def connected?
      begin
        serial = Serial.new(@port_str, @baud_rate)
        response = send_at_command(serial, "AT")
        serial.close
        response.include?("OK") # Check if the response contains "OK"
      rescue Exception => e
        puts "Error checking connection: #{e.message}"
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
      return response
    end
  end
end
