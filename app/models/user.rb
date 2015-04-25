class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :votes
  has_many :friendships
  has_many :friends, :through => :friendships, :conditions => "status = 2" #accepted friends
  has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 1" #the ones who requested a friendship with this user
  has_many :pending_friends, :through => :friendships, :source => :friend, :conditions => "status = 0" #the ones for whom this user asked for a friendship
  has_many :cvotes, dependent: :destroy
  has_many :cvote_trackers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, :foreign_key => :user_me, dependent: :destroy
  has_many :polls, dependent: :destroy
  has_many :pvotes, dependent: :destroy
  has_many :vote_options, through: :pvotes
  has_one :status, dependent: :destroy
  has_many :svotes, dependent: :destroy
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
    votes.find_by(post_id:  post.id)
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
  
  def self.from_omniauth(auth)
    where(auth.slice(:email)).first_or_initialize.tap do |user|
    #user.provider = auth.provider
    #user.uid = auth.uid
    #user.name = auth.info.name
    #user.username = auth.info.nickname
    #user.image = auth.info.image
    
    user = User.find_by_email(auth.info.email)

    if user.nil?
      #Rails.logger.info(auth)
      user = User.new   
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.profile_image = auth.info.image + "?type=large" 
      user.email = auth.info.email
      if auth.info.gender == "male"
        user.gender = true
      else
        user.gender = false
      end
      user.admin = "false"
      user.password = "from_facebook"
      user.password_confirmation = "from_facebook"
      #preloaded = Cloudinary::PreloadedFile.new(user.profile_image, {:crop => :fill, :width => 168, :height => 168})         
      #raise "Invalid upload signature" if !preloaded.valid?
      #user.profile_image = preloaded.identifier
      @img = Cloudinary::Uploader.upload(user.profile_image, {:crop => :fill, :width => 168, :height => 168})
      user.profile_image = @img['public_id']      
      user.save!
    end
    
    #user.bio = auth.info.extra.raw_info.bio
    #user.oauth_token = auth.credentials.token
    #user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    #user.save!
    return user
    end
  end
  
  def voted_for?(poll)
    vote_options.any? {|v| v.poll == poll }
  end
  
  def voted_for_status?(i)
    svotes.find_by_status_id(i)
  end
  
  def status_votes_up
    Svote.find_all_by_status_id_and_svote_status(status.id, 2).count
  end
  
  def status_votes_down
    Svote.find_all_by_status_id_and_svote_status(status.id, 1).count
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
