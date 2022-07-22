module Web
  class Element
    attr_accessor :line, :attributes, :text, :tag

    def initialize(tag: "", text: "", line: 0)
      self.tag = tag
      self.text = text
      self.line = line
      self.attributes = []
    end

    def add_attribute(name, value)
      self.attributes.push(Web::Attribute.new(name, value))
    end

    def xss_lines
      xsses = Array.new
      self.attributes.each do |attribute|
        xsses.push(self.line + attribute.alert_at_line - 1) unless attribute.alert_at_line.nil?
      end

      xsses
    end
  end
end
