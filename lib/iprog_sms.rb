# frozen_string_literal: true
# lib/iprog_sms.rb

require_relative "../lib/iprog_sms/version"
require_relative "../lib/iprog_sms/sms"
require_relative "../lib/iprog_sms/api_client"
require_relative "../lib/iprog_sms/sender"
require_relative '../lib/iprog_sms/sim800c_troubleshoot'

module IprogSms
 # Method to run the SIM800C troubleshooting script
 def self.troubleshoot_sim800c(port_str)
  IprogSms::Sim800cTroubleshoot.troubleshoot_sim800c(port_str)
 end
end
