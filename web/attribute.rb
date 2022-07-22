module Web
  class Attribute
    HTML_EVENTS = %{\Aonafterprint|onbeforeprint|onbeforeunload|
      onerror|onhashchange|onload|onmessage|onoffline|ononline|onpagehide|
      onpageshow|onpopstate|onresize|onstorage|onunload|onblur|onchange|
      oncontextmenu|onfocus|oninput|oninvalid|onreset|onsearch|onselect|
      onsubmit|onkeydown|onkeypress|onkeyup|onclick|ondblclick|onmousedown|
      onmousemove|onmouseout|onmouseover|onmouseup|onmousewheel|onwheel|
      ondrag|ondragend|ondragenter|ondragleave|ondragover|ondragstart|ondrop|
      onscroll|oncopy|oncut|onpaste|onabort|oncanplay|oncanplaythrough|
      oncuechange|ondurationchange|onemptied|onended|onerror|onloadeddata|
      onloadedmetadata|onloadstart|onpause|onplay|onplaying|onprogress|onratechange|
      onseeked|onseeking|onstalled|onsuspend|ontimeupdate|onvolumechange|onwaiting\z}

    attr_accessor :name, :value, :alert_at_line

    def initialize(name, value)
      self.name = name
      self.value = value
      self.has_alert?
    end

    private
    def has_alert?
      return false if self.name.match(Regexp.new(Web::Attribute::HTML_EVENTS)).nil?

      self.alert_at_line = 1

      stack = Array.new
      aux_value = self.value
      aux_value.split(//).each_index do |i|
        self.alert_at_line += 1 if aux_value[i].match(/[\r\n]/)

        if stack.size > 0 && stack.last.match(/\A\"|\'\z/)
          stack.pop if (aux_value[i-1].nil? || aux_value[i-1] != "\\") && aux_value[i].match(/\A\"|\'\z/)
        else
          stack.push(aux_value[i])
        end

        return true unless stack.join('').match(/([^\w]{1}|^)alert\(.*\)/).nil?
      end

      self.alert_at_line = nil
      false
    end
  end
end
