require 'erb'

class ErbRenderer
  include Sickill::Helpers

  def initialize(src)
    @src = src
  end

  def render
    ERB.new(@src).result(binding)
  end
end
