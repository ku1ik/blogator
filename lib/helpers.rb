module Sickill
  module Helpers

    def link_to(name, href)
      %(<a href="#{href}">#{name}</a>)
    end

#    def partial(name, options={})
#      erb "_#{name}".to_sym, options.merge!(:layout => false)
#    end

    def partial(template, *args)
      options = args.extract_options!
      options.merge!(:layout => false)
      path = template.to_s.split(File::SEPARATOR)
      object = path[-1].to_sym
      path[-1] = "_#{path[-1]}"
      template = File.join(path).to_sym
      if collection = options.delete(:collection)
        collection.inject([]) do |buffer, member|
            buffer << erb(template, options.merge(:layout => false, :locals => {object => member}))
        end.join("\n")
      else
        erb(template, options)
      end
    end

    def image(thumb, normal, desc="")
      %(<a href="#{normal}" title="#{desc}"><img src="#{thumb}" alt="#{desc}" /></a>)
    end

    def rfc_date(datetime)
      datetime.strftime("%Y-%m-%dT%H:%M:%SZ") # 2003-12-13T18:30:02Z
    end

    def render_static_page(data)
      RedCloth.new(ERB.new(data).result(binding)).to_html
    end
  end
end
