class Post
  include DataMapper::Resource

  property :id,          Serial
  property :title,       String, :length => 255, :nullable => false, :unique => true
  property :formatter,   Enum[:none, :textile], :nullable => false, :default => :textile
  property :slug,        String, :length => 255, :nullable => false, :unique => true
  property :body,        Text, :nullable => false, :lazy => false
  property :body_source, Text, :nullable => false
  property :draft,       Boolean, :nullable => false, :default => false
  property :created_at,  DateTime
  property :updated_at,  DateTime

  has n, :taggings
  has n, :tags, :through => :taggings

  default_scope(:default).update(:draft => false)

  before :valid? do
    self.body = self.class.format(self.body_source, self.formatter)
    self.slug = self.title.downcase.gsub(/\s+/, '-').gsub(/\-{2,}/, '-').gsub(/[^a-z0-9\-]/, '') if self.id.nil? && self.slug.nil?
  end

  before :destroy do
    self.taggings.all.destroy!
  end

  after :update do
    self.tags.each { |t| t.recount_usage }
  end

  before :create, :update_tags
  before :update, :update_tags

  def self.all_records
    all(:draft => [true, false])
  end

  def self.format(src, formatter)
    src = ErbRenderer.new(src).render
    case formatter
    when :textile
      RedCloth.new(src).to_html
    else
      src
    end
  end

  def draft=(value)
    attribute_set(:draft, value.is_a?(Array) ? value.first : value)
  end

  def tag_list=(value)
    @tag_list = value.split(",").map { |t| t.strip }.reject { |t| t.empty? }.uniq.join(", ")
  end

  def tag_list
    @tag_list || self.tags.map { |t| t.name }.sort.join(", ")
  end

  def url
    "/blog/#{self.created_at.strftime('%Y/%m/%d')}/#{self.slug}.html"
  end

  protected
  def update_tags
    new_tags = @tag_list.split(", ")
    old_tags = self.tags.reload.map { |t| t.name }
    (old_tags - new_tags).each { |tag_name| self.taggings.first(:tag_id => Tag[tag_name].id).destroy }
    (new_tags - old_tags).each { |tag_name| self.taggings << Tagging.new(:tag => Tag[tag_name]) }
  end
end

class Tagging
  include DataMapper::Resource

  property :id,      Serial
  property :post_id, Integer, :nullable => false
  property :tag_id,  Integer, :nullable => false

  belongs_to :post
  belongs_to :tag

  validates_is_unique :tag_id, :scope => :post_id

  after :create,  :update_usage
  after :destroy, :update_usage

  protected
  def update_usage
    self.tag.recount_usage
  end
end

class Tag
  include DataMapper::Resource

  property :id,          Serial
  property :name,        String, :length => 64, :nullable => false
  property :posts_count, Integer, :nullable => false, :default => 0

  has n, :taggings
  has n, :posts, :through => :taggings, :order => [:created_at.desc], :unique => true

  def self.[](name)
    first(:name => name) || Tag.create(:name => name)
  end

  def self.recount_usage
    all.each do |tag|
      tag.recount_usage
    end
  end

  def recount_usage
    self.posts_count = self.posts.all.size
    save
  end
end
