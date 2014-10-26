class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :votes
  has_many :friendships
  has_many :friends, :through => :friendships, :conditions => "status = 2" #accepted friends
  has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 1" #the ones who requested a friendship with this user
  has_many :pending_friends, :through => :friendships, :source => :friend, :conditions => "status = 0" #the ones for whom this user asked for a friendship
  has_many :cvotes, dependent: :destroy
  has_many :cvote_trackers, dependent: :destroy
  belongs_to :country
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :first_name, presence: true, length: { maximum: 30 }
  validates :last_name, presence: true, length: {maximum: 30}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }
  validates_inclusion_of :gender, :in => [true, false]
  has_secure_password
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def voted?(post)
    votes.find_by(post_id: post.id)
  end

  def vote!(post)
    votes.create!(post_id: post.id, category_id: post.category_id)
  end
  
  def unvote!(post)
    votes.find_by(post_id: post.id).destroy
  end
  
  def cvoted?(cvote)
    cvote_trackers.find_by(cvote_id: cvote.id)
  end
  
  def cvote!(cvote,answer)
    cvote_trackers.create!(cvote_id: cvote.id, answer_id: answer)
  end
  
  def cunvote!(cvote)
    
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
