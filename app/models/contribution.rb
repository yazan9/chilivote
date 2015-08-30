class Contribution < ActiveRecord::Base
  belongs_to :user
  has_many :likes, :foreign_key => :target_id, dependent: :destroy
  has_many :options, dependent: :destroy
  has_many :comments, :foreign_key => :cvote_id, dependent: :destroy
end
