class Poll < ActiveRecord::Base
  belongs_to :user
  has_many :vote_options, dependent: :destroy
  validates :topic, presence: true
  accepts_nested_attributes_for :vote_options, :reject_if => :all_blank, :allow_destroy => true
  validate :require_two_options
  has_many :pvotes, dependent: :destroy
  
  private
    def require_two_options
      errors.add(:base, "You must provide at least two answers") if vote_options.size < 2
    end
end
