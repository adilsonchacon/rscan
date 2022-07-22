class String
  def remove_quoted_parts
    self.gsub(/([\"].*?[\"])|(['].*?['])/, '')
  end
end
