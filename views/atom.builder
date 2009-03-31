xml.instruct! :xml, :version => '1.0', :encoding => 'utf-8'
xml.feed :'xml:lang' => 'en-US', :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.id "http://sickill.net"
  xml.link :type => 'text/html', :href => "http://sickill.net", :rel => 'alternate'
  xml.link :type => 'application/atom+xml', :href => "http://sickill.net/atom/feed", :rel => 'self'
  xml.title "Marcin Kulik's tech stuff"
  xml.subtitle "#{h('sickill.net')}"
  xml.updated(@posts.first ? rfc_date(@posts.first.created_at) : rfc_date(Time.now.utc))
  @posts.each do |post|
    xml.entry do |entry|
      entry.id "http://sickill.net#{post.url}"
      entry.link :type => 'text/html', :href => "http://sickill.net#{post.url}", :rel => 'alternate'
      entry.updated rfc_date(post.created_at)
      entry.title post.title
#      entry.summary post.perex, :type => 'html'
      entry.content post.body, :type => 'html'
      entry.author do |author|
        author.name "Marcin Kulik" # Marley::Configuration.blog.author || hostname
#        author.email(Marley::Configuration.blog.email) if Marley::Configuration.blog.email
      end
    end
  end
end