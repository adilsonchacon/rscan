module Lib
  class Printer
    class << self
      def help
        print %{
Usage:
  ruby main.rb [options]

Options:
  -p, [--path]   # /path/to/file (or directory of files) to be scanned
  -xss           # execute XSS scan against HTML (.html) and Javascript (.js) files only
  -sqli          # execute SQL Injection scan against all files
  -expo          # execute Data Exposure scan against all files
  -o, [--output] # output format: text for Plain text (default) or json for JSON
  -h, [--help]   # tshows this help

        }
      end

      def results(output, results)
        if output.downcase == 'text'
          result_as_plain_text(results)
        else
          result_as_json(results)
        end
      end

      private
      def result_as_plain_text(results)
        results.each do |result|
          print "[#{result[:vulnerability]}] in file \"#{result[:file]}\" on line #{result[:line].to_s}\n"
        end
      end

      def result_as_json(results)
        results_as_hash = Hash.new
        results.each do |result|
          results_as_hash[result[:vulnerability]] ||= []
          results_as_hash[result[:vulnerability]].push({ file: result[:file], line: result[:line] })
        end

        print results_as_hash.to_s
      end
    end
  end
end
