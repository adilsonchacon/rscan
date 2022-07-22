require 'nokogiri'

module Scan
  class SensitiveDataExposure
    attr_accessor :filename, :filecontent, :exposed_lines

    def initialize(filename)
      self.exposed_lines = Array.new

      self.filename = filename
      self.filecontent = File.read(self.filename)
    end

    def parse
      line_counter = 0
      self.filecontent.split(/[\n\r]/).each do |line|
        line_counter += 1
        exposed_lines.push(line_counter) if line.match(/checkmarx/i) && line.match(/hellman\s\&\sfriedman/i) && line.match(/\$1\.15b/i)
      end
    end

    def report
      results = Array.new

      self.exposed_lines.each do |exposed_line|
        results.push({ file: self.filename, line: exposed_line, vulnerability: 'Sensitive Data Exposure' })
      end

      results
    end
  end
end
