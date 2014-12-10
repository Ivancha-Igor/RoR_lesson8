class Post < ActiveRecord::Base
  validates_presence_of :title, :body, :user_id
  validates_uniqueness_of :title, scope: :user
  validates_length_of :title, in: 5..140
  validates_length_of :body, minimum: 140

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :votes

  scope :newest, -> {order(:created_at).reverse}
  scope :active, -> {order(:updated_at).reverse}
  scope :popular, -> {order(:created_at).sort_by{|post| post.rating}.reverse}

  def rating
    self.votes.where(rating: true).count - self.votes.where(rating: false).count
  end

  after_create :post_touch

  def post_touch
    self.touch
  end
end
