module Lib
  class FileHelper
    attr_accessor :path, :files

    def initialize(path)
      self.path = path
      self.files = []
      load_files
    end

    private
    def load_files
      if is_path_a_dir?
        self.files = Dir.glob("#{path}/**/*").reject { |e| File.directory? e }
      elsif File.exist?(path)
        self.files = [path]
      else
        raise StandardError.new("path does not exist")
      end
    end

    def is_path_a_dir?
      File.directory?(path)
    end
  end
end
