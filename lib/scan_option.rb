module Lib
  class ScanOption
    attr_accessor :error_message

    def initialize(args)
      @options = {
        path: nil,
        output: 'text',
        xss: false,
        sqli: false,
        expo: false
      }

      parse_args(args)
      check_for_error_message
      raise StandardError.new(self.error_message) unless self.error_message.nil?
    end

    def path
      @options[:path]
    end

    def output
      @options[:output]
    end

    def xss
      @options[:xss]
    end

    def sql_injection
      @options[:sqli]
    end

    def sensitive_data_exposure
      @options[:expo]
    end

    private
    def parse_args(args)
      (0..(args.size-1)).each do |i|
        @options[:path] = parse_path_arg(i, args)
        @options[:output] = parse_output_arg(i, args)
        @options[:xss] = true if args[i] == '-xss'
        @options[:sqli] = true if args[i] == '-sqli'
        @options[:expo] = true if args[i] == '-expo'
      end
    end

    def parse_path_arg(i, args)
      if (args[i] == '-p' || args[i] == '--path') && !args[i+1].nil?
        return args[i+1]
      elsif args[i].match(/\A(\-p)|(\-\-path)\=/)
        return args[i].split('=')[1]
      end

      @options[:path]
    end

    def parse_output_arg(i, args)
      if (args[i] == '-o' || args[i] == '--output') && !args[i+1].nil?
        return args[i+1]
      elsif args[i].match(/\A(\-o)|(\-\-output)\=/) && args[i].split('=').size > 0
        return args[i].split('=')[1]
      end

      @options[:output]
    end

    def check_for_error_message
      self.error_message = nil

      if @options[:path].nil?
        self.error_message = 'invalid path'
      elsif !(Dir.exist?(@options[:path]) || File.exist?(@options[:path]))
        self.error_message = 'path does not exist'
      elsif !['text', 'json'].include?(@options[:output].downcase)
        self.error_message = 'invalid output type'
      elsif !@options[:xss] && !@options[:sqli] && !@options[:expo]
        self.error_message = 'no scan chosen'
      end
    end

  end
end
