# stave/lib/stave/core_ext.rb

class String
  def to_squawk
    "squawk! #{self}".strip
  end
end
