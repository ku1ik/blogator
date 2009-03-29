module Sickill
  module Helpers

    def link_to(name, href)
      %(<a href="#{href}">#{name}</a>)
    end

    def partial(name, options={})
      erb "_#{name}".to_sym, options.merge!(:layout => false)
    end

    def image(thumb, normal, desc="")
      %(<a href="#{normal}" title="#{desc}"><img src="#{thumb}" alt="#{desc}" /></a>)
    end
    
  end
end
