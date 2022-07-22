require 'nokogiri'

Dir["#{File.dirname(__FILE__)}/../web/*.rb"].each {|file| require file }
Dir["#{File.dirname(__FILE__)}/../modifiers/*.rb"].each {|file| require file }

module Scan
  class Xss
    attr_accessor :filename, :filecontent, :web_elements

    def initialize(filename)
      self.web_elements = Array.new

      self.filename = filename
      self.filecontent = File.read(self.filename)

      @filecontent_temp_lines = self.filecontent.split(/[\r\n]/)
    end

    def parse
      if self.filename.split('.').last.downcase == 'js'
        self.parseJavascript
      elsif self.filename.split('.').last.downcase == 'html'
        self.parseHtml
      else
        print "WARN!!! invalid file for XSS scan. Only HTML and JS files are allowed.\n"
        false
      end
    end

    def parseHtml
      begin
        parsed_data = Nokogiri::HTML.parse(self.filecontent)
        parsed_data.xpath('/').children.each do |path|
          self.identify_xss(path)
        end
      rescue Exception => e
        p e
        return false
      end

      true
    end

    def parseJavascript
      begin
        @filecontent_temp_lines.each_index do |line|
          @filecontent_temp_lines[line] = @filecontent_temp_lines[line].remove_quoted_parts
        end

        js_attribute = JsAttributteAdapter.new(value: @filecontent_temp_lines.join("\n"))

        tag = JsAdapter.new(name: 'js')
        tag.attributes = { 'onload' => js_attribute }

        identify_xss(tag)
      rescue Exception => e
        p e
        return false
      end

      true
    end

    def report
      results = Array.new

      web_elements.each do |web_element|
        web_element.xss_lines.each do |xss_line|
          results.push({ file: self.filename, line: xss_line, vulnerability: 'XSS' })
        end
      end

      results
    end

    private
    def identify_xss(tag)
      web_element = Web::Element.new(tag: tag.name, text: tag.text)
      begin
        tag.attributes.keys.each do |key|
          value = tag.attributes[key].value
          web_element.add_attribute(key, value)
        end
      rescue Exception => e
      end

      if web_element.tag == 'script'
        web_element.add_attribute('onload', web_element.text)
      end

      self.add_web_element(web_element)

      tag.children.each do |child|
        next unless child.is_a?(Nokogiri::XML::Element)
        self.identify_xss(child)
      end
    end

    def add_web_element(new_web_element)
      line = new_web_element.tag == 'js' ? 1 : line_of_web_element(new_web_element)
      new_web_element.line = line unless line.nil?

      self.web_elements.push(new_web_element)
    end

    def line_of_web_element(web_element)
      regexp = Regexp.new("<#{web_element.tag}", Regexp::IGNORECASE)

      @filecontent_temp_lines.each_index do |line|
        if @filecontent_temp_lines[line].match(regexp)
          @filecontent_temp_lines[line] = ""
          return line + 1
        end
      end

      nil
    end
  end
end
