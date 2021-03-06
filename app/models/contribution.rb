class Contribution < ActiveRecord::Base
  belongs_to :user
  has_many :likes, :foreign_key => :target_id, dependent: :destroy
  has_many :options, dependent: :destroy
  has_many :comments, :foreign_key => :cvote_id, dependent: :destroy
  #Opppaaa
  
  def self.search_chilivotes(q)
    Contribution.where(['lower(title) LIKE ? AND contribution_type = ?', "%#{q}%", Chilivote::Application.config.contribution_type_cvote])
  end
  
  def self.search_statuses(q)
    Contribution.where(['lower(body) LIKE ? AND contribution_type = ?', "%#{q}%", Chilivote::Application.config.contribution_type_status])
  end
end
