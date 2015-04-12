class Status < ActiveRecord::Base
  #status_type = 1 for text and 2 for image
  belongs_to :user
  has_many :svotes
end
