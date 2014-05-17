class Category < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  validates :name, :description, :image_id, presence: true
end
