class Category < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :votes, dependent: :destroy
  validates :name, :description, :image_id, presence: true
  
  def show_name
    self.name
  end
end
