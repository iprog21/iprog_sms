# frozen_string_literal: true
# lib/iprog_sms/sms.rb

require 'rubyserial'

module IprogSms
  class SMS
    def initialize
      @baud_rate = 9600
      @port_str = detect_sim800c || "/dev/ttyUSB0"  # Detect SIM800C port automatically
    end

    def send_sms(phone_number, message)
      if connected?
        begin
          # Open the serial connection
          serial = Serial.new(@port_str, @baud_rate)

          # Set SMS to text mode
          send_at_command(serial, "AT+CMGF=1")

          # Specify the recipient phone number
          send_at_command(serial, "AT+CMGS=\"#{phone_number}\"")

          # Send the actual SMS message, followed by Ctrl+Z (ASCII 26)
          send_at_command(serial, "#{message}\x1A", 5)

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

    def detect_sim800c
      # List all potential serial ports (Linux/macOS). For Windows, replace with 'COM*'.
      potential_ports = Dir['/dev/ttyUSB*'] + Dir['/dev/tty.usbserial*'] + Dir['/dev/tty.*']

      potential_ports.each do |port|
        puts "Checking port: #{port}"
        begin
          # Try opening the port
          serial = Serial.new(port, @baud_rate)

          # Send the AT command
          serial.write("AT\r")
          sleep(1) # Wait for a response
          response = serial.read(100)

          # If the response contains "OK", it's likely the SIM800C
          if response.include?("OK")
            puts "SIM800C detected on port: #{port}"
            serial.close
            return port  # Return the correct port
          else
            puts "No response from #{port}, moving to next port..."
            serial.close
          end
        rescue StandardError => e
          puts "Error on #{port}: #{e.message}"
        end
      end

      # If no SIM800C is detected
      puts "No SIM800C module detected."
      nil
    end

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
