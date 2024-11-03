# lib/iprog_sms/sim800c_troubleshoot.rb
require 'rubyserial'

module IprogSms
  module Sim800cTroubleshoot
    # Sends an AT command to the SIM800C and reads the response
    def self.send_at_command(serial, command, wait_time = 1)
      puts "Sending command: #{command}"
      serial.write("#{command}\r")
      sleep(wait_time)
      response = serial.read(1000)
      puts "Response: #{response}"
      response
    rescue StandardError => e
      puts "Error sending command #{command}: #{e.message}"
      nil
    end

    # Set message storage location to SIM card
    def self.set_message_storage(serial)
      response = send_at_command(serial, 'AT+CPMS="SM","SM","SM"')
      if response&.include?("OK")
        puts "Message storage set to SIM card (SM)."
      else
        puts "Failed to set message storage location."
      end
    end

    # Set message format to text mode
    def self.set_text_mode(serial)
      response = send_at_command(serial, "AT+CMGF=1")
      if response&.include?("OK")
        puts "Message format set to Text Mode."
      else
        puts "Failed to set message format to Text Mode."
      end
    end

    # Check signal strength
    def self.check_signal_strength(serial)
      response = send_at_command(serial, "AT+CSQ")
      if response&.include?("+CSQ")
        signal_strength = response.match(/\+CSQ: (\d+)/)[1].to_i
        puts "Signal strength: #{signal_strength}"
        if signal_strength < 10
          puts "Warning: Low signal strength may affect message delivery."
        else
          puts "Signal strength is adequate."
        end
      else
        puts "Failed to retrieve signal strength."
      end
    end

    # List all messages in the inbox
    def self.list_messages(serial)
      response = send_at_command(serial, 'AT+CMGL="ALL"')
      if response&.include?("+CMGL")
        puts "Messages in inbox:\n#{response}"
      else
        puts "No messages found in the inbox or unable to retrieve messages."
      end
    end

    # Restart the SIM800C module (if supported)
    def self.restart_module(serial)
      response = send_at_command(serial, "AT+CFUN=1,1")
      if response&.include?("OK")
        puts "Module restarted successfully."
      else
        puts "Failed to restart the module. Try manually if this command is unsupported."
      end
    end

    # Main troubleshooting function
    def self.troubleshoot_sim800c(port_str)
      begin
        serial = Serial.new(port_str, 9600) # Adjust baud rate if necessary
        puts "Starting SIM800C troubleshooting..."

        # Step 1: Set message storage to SIM card
        set_message_storage(serial)

        # Step 2: Set message format to Text Mode
        set_text_mode(serial)

        # Step 3: Check signal strength
        check_signal_strength(serial)

        # Step 4: List all messages in the inbox
        list_messages(serial)

        # Step 5: Restart the module if needed
        puts "Do you want to restart the module? (y/n)"
        if gets.chomp.downcase == 'y'
          restart_module(serial)
        end

      rescue StandardError => e
        puts "Error: #{e.message}"
      ensure
        serial&.close
        puts "Troubleshooting complete."
      end
    end
  end
end
