class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  has_ancestry

  validates_presence_of :body

  after_create :update_post
  def update_post
    self.post.touch
  end
end
