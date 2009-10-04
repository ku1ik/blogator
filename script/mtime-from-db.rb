Post.all.published.each { |p| puts "touch -mt #{p.updated_at.strftime('%y%m%d%H%M')} " + p.published_at.strftime('%Y-%m-%d') + "-" + p.slug + ".textile" 

