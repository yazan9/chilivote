class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :votes
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :first_name, presence: true, length: { maximum: 30 }
  validates :last_name, presence: true, length: {maximum: 30}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }
  validates_inclusion_of :gender, :in => [true, false]
  has_secure_password
  validates :password, length: { minimum: 6 }
  
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

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
