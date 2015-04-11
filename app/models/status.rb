class Status < ActiveRecord::Base
  belongs_to :user
  has_many :svotes
end
