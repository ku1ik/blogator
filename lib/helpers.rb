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

    def rfc_date(datetime)
      datetime.strftime("%Y-%m-%dT%H:%M:%SZ") # 2003-12-13T18:30:02Z
    end
  end
end
