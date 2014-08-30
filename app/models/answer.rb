class Answer < ActiveRecord::Base
  #those are the options for a cvote
  belongs_to :cvote
  belongs_to :user
end
