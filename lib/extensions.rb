class Object
  ##
  #   @person ? @person.name : nil
  # vs
  #   @person.try(:name)
  def try(method)
    send method if respond_to? method
  end
end

if RUBY_VERSION < "1.8.7"
  class Array
    def group_by
      inject({}) do |groups, element|
        (groups[yield(element)] ||= []) << element
        groups
      end
    end
  end
end

class Hash
  def map
    self.each do |key, value|
      self[key] = yield(key, value)
    end
  end
end
