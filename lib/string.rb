class String
  def patronize
    humanize.gsub(/\b(\p{L}+)/) { |word| word.capitalize }
  end
end
