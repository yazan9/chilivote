class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favored_user, :class_name => "User", :foreign_key => "favorite_id"
  validates_presence_of :user_id, :favorite_id
  
  def self.exists?(user, friend)
    not find_by_user_id_and_favorite_id(user, friend).nil?
  end
  
  def self.favor(user,friend)
    unless user == friend
      transaction do
        @user_to_friend = create(:user=>user, :favored_user => friend)
      end
    end
    @user_to_friend
  end
  
  def self.unfavor(user,friend)
    transaction do
      destroy(find_by_user_id_and_favorite_id(user.id,friend.id))
    end
  end
end
