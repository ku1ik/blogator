Post.all.each { |p| File.open("#{(p.published_at || p.updated_at).strftime('%Y-%m-%d')}-#{p.slug}.#{p.formatter}", "w") { |f| f.puts "---\ntitle: #{p.title}\ntags: #{p.tag_list}\n\nlayout: post\n---\n\n#{p.body_source.gsub(/\r\n/, "\n")}" } }

