class Pvote < ActiveRecord::Base
  belongs_to :user
  belongs_to :vote_option
  belongs_to :poll
end
