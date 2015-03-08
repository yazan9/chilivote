class VoteOption < ActiveRecord::Base
  belongs_to :poll
  validates :title, presence: true
  has_many :pvotes, dependent: :destroy
  has_many :users, through: :votes
end
