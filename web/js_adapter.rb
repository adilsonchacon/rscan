class JsAdapter
  attr_accessor :name, :text, :attributes, :children

  def initialize(name: '', text: '')
    self.name = name
    self.text = text
    self.attributes = {}
    self.children = []
  end
end

class JsAttributteAdapter
  attr_accessor :value

  def initialize(value: '')
    self.value = value
  end
end
