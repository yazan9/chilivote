class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :votes, dependent: :destroy
  #validates :user_id, :parent_id, :img_url, presence: true
  
  def previous_post
    Post.where(["id < ?", id]).where(["category_id == ? ", category_id]).last
  end
  
  def next_post
    Post.where(["id > ?", id]).where(["category_id == ? ", category_id]).first
  end
end
