# frozen_string_literal: true
# iprog_sms.gemspec

require_relative 'lib/iprog_sms/version'

Gem::Specification.new do |spec|
  spec.name                            = "iprog_sms"
  spec.version                         = IprogSms::VERSION
  spec.authors                         = ["Jayson Presto"]
  spec.email                           = ["jaysonpresto.iprog21@gmail.com"]

  spec.summary                         = "A gem to send SMS using SIM800C and Ruby."
  spec.description                     = "This gem allows you to send SMS using the SIM800C module and supports fetching SMS details from an API."
  spec.homepage                        = "https://rubygems.org/gems/iprog_sms"
  spec.license                         = "MIT"
  spec.required_ruby_version           = ">= 2.5.0"

  spec.files                           = Dir["lib/**/*.rb"]
  spec.require_paths                   = ["lib"]

  spec.metadata["homepage_uri"]        = spec.homepage
  spec.metadata["source_code_uri"]     = "https://github.com/iprog21/iprog_sms.git"
  spec.metadata["changelog_uri"]       = "https://github.com/iprog21/iprog_sms/blob/master/CHANGELOG.md"
  spec.metadata["code_of_conduct_uri"] = "https://github.com/iprog21/iprog_sms/blob/main/CODE_OF_CONDUCT.md"

  # Adding rubyserial as a dependency
  spec.add_dependency "rubyserial", "~> 0.3.0"

  # Adding bin executables
  spec.executables << 'iprog_sms_troubleshoot'
  spec.executables << 'iprog_send_sms'
  spec.executables << 'iprog_send_sms_from_api'
end
