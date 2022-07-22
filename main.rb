#!/usr/bin/env ruby

require 'json'
Dir["#{File.dirname(__FILE__)}/scan/*.rb"].each {|file| require file }
Dir["#{File.dirname(__FILE__)}/lib/*.rb"].each {|file| require file }

if ARGV.size == 0 || ARGV.include?('-h') || ARGV.include?('--help')
  Lib::Printer.help
  exit(1)
end

begin
  scan_option = Lib::ScanOption.new(ARGV)
  files = Lib::FileHelper.new(scan_option.path).files
rescue StandardError => standard_error
  p "Error: #{standard_error}"
  Lib::Printer.help
  exit(1)
end

results = Array.new

files.each do |file|
  if scan_option.xss
    scan_xss = Scan::Xss.new(file)
    scan_xss.parse
    results += scan_xss.report
  end

  if scan_option.sql_injection
    scan_sqli = Scan::SqlInjection.new(file)
    scan_sqli.parse
    results += scan_sqli.report
  end

  if scan_option.sensitive_data_exposure
    scan_expo = Scan::SensitiveDataExposure.new(file)
    scan_expo.parse
    results += scan_expo.report
  end
end

Lib::Printer.results(scan_option.output, results)
