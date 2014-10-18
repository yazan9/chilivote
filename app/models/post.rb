class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :votes, dependent: :destroy
  #validates :user_id, :parent_id, :img_url, presence: true
  
  def previous_post(view_by)
    #Post.where(["id < ?", id]).where(["category_id = ? ", category_id]).last
    if view_by == "recent"
      Post.where(["id > ?", id]).where(["category_id = ? ", category_id]).first
    elsif view_by == "random"
      Post.where(:category_id => category_id).limit(1).order("RANDOM()").first
    elsif view_by == "most_voted"
    else
      Post.where(["id < ?", id]).where(["category_id = ? ", category_id]).last
    end
  end
  
  def next_post(view_by)
    #Post.where(["id > ?", id]).where(["category_id = ? ", category_id]).first
    if view_by == "recent"
      Post.where(["id < ?", id]).where(["category_id = ? ", category_id]).last
    elsif view_by == "random"
      Post.where(:category_id => category_id).limit(1).order("RANDOM()").first
    elsif view_by == "most_voted"
    else
      Post.where(["id > ?", id]).where(["category_id = ? ", category_id]).first
    end
  end
end
