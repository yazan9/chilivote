class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  #validates :user_id, :parent_id, :img_url, presence: true
end
