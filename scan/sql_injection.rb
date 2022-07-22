require 'nokogiri'

module Scan
  class SqlInjection
    attr_accessor :filename, :filecontent, :sqli_lines

    def initialize(filename)
      self.sqli_lines = Array.new

      self.filename = filename
      self.filecontent = File.read(self.filename)
    end

    def parse
      current_char_position = -1
      first_quote_position = -1
      line_counter = self.filecontent.size > 0 ? 1 : 0

      self.filecontent.split(//).each do |current_char|
        line_counter += 1 if current_char.match(/[\n\r]/)
        current_char_position += 1
        if current_char == '"'
          if first_quote_position < 0
            first_quote_position = current_char_position
          elsif first_quote_position >= 0
            quoted_text = self.filecontent[first_quote_position..current_char_position]
            lines_in_quote = quoted_text.scan(/[\r\n]/).size
            sqli_lines.push(line_counter - lines_in_quote) if quoted_text.gsub(/[\n\r]/, ' ').match(/\".*SELECT.*WHERE.*\%s.*\"/i)
            first_quote_position = -1
          end
        end
      end
    end

    def report
      results = Array.new

      self.sqli_lines.each do |sqli_line|
        results.push({ file: self.filename, line: sqli_line, vulnerability: 'SQL Injection' })
      end

      results
    end
  end
end
