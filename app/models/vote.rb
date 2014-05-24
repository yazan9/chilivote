class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :category
  validates :user_id, presence: true
  validates :post_id, presence: true
end
