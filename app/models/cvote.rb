class Cvote < ActiveRecord::Base
  belongs_to :user
  has_many :answers
end