module ApplicationHelper
  def user_avatar(user)
    @avatar = "<div class='avatar_box'>"
    @avatar += cl_image_tag user.profile_image ? (user.profile_image) : Chilivote::Application.config.default_profile_image , :width=>40, :height => 40, :crop => :thumb
    @avatar += "<span class='user_name_in_avatar'>"
    @avatar += link_to user.first_name + " " + user.last_name, {:controller => 'users', :action => 'show_profile', :id => user.id}
    @avatar += "</span>"
    @avatar += "</div>"
  end
  
  def user_avatar_one_line(user)
    @avatar = "<span class='avatar_box'>"
    @avatar += cl_image_tag user.profile_image ? (user.profile_image) : Chilivote::Application.config.default_profile_image , :width=>40, :height => 40, :crop => :thumb
    @avatar += "<span class='user_name_in_avatar'>"
    @avatar += link_to user.first_name + " " + user.last_name, {:controller => 'users', :action => 'show_profile', :id => user.id}
    @avatar += "</span>"
    @avatar += "</span>"
  end
  
  def user_avatar_one_line_small(user)
    @avatar = "<span class='avatar_box'>"
    @avatar += cl_image_tag user.profile_image ? (user.profile_image) : Chilivote::Application.config.default_profile_image , :width=>25, :height => 25, :crop => :thumb
    @avatar += "<span class='user_name_in_avatar'>"
    @avatar += link_to user.first_name + " " + user.last_name, {:controller => 'users', :action => 'show_profile', :id => user.id}
    @avatar += "</span>"
    @avatar += "</span>"
  end
  
   def user_avatar_one_line_small_truncated(user)
    @avatar = "<span class='avatar_box'>"
    @avatar += cl_image_tag user.profile_image ? (user.profile_image) : Chilivote::Application.config.default_profile_image , :width=>25, :height => 25, :crop => :thumb
    @avatar += "<span class='user_name_in_avatar'>"
    @avatar += link_to truncate(user.first_name + " " + user.last_name, :length => 20), {:controller => 'users', :action => 'show_profile', :id => user.id}
    @avatar += "</span>"
    @avatar += "</span>"
  end
  
  def user_avatar_one_line_small_photo(user)
    @avatar = "<span class='avatar_box pull-left'>"
    @avatar += cl_image_tag user.profile_image ? (user.profile_image) : Chilivote::Application.config.default_profile_image , :width=>25, :height => 25, :crop => :thumb
    @avatar += "</span>"
  end
  
  def user_avatar_one_line_medium_photo(user)
    @avatar = "<span class='avatar_box pull-left'>"
    @avatar += cl_image_tag user.profile_image ? (user.profile_image) : Chilivote::Application.config.default_profile_image , :width=>40, :height => 40, :crop => :thumb
    @avatar += "</span>"
  end
  
  def user_avatar_one_line_no_link(user)
    @avatar = "<span class='avatar_box'>"
    @avatar += cl_image_tag user.profile_image ? (user.profile_image) : Chilivote::Application.config.default_profile_image , :width=>40, :height => 40, :crop => :thumb
    @avatar += "<span class='user_name_in_avatar'>"
    @avatar += user.first_name + " " + user.last_name
    @avatar += "</span>"
    @avatar += "</span>"
  end
  
  def user_avatar_no_image(user)
    @avatar = ""
    @avatar += link_to user.first_name + " " + user.last_name, {:controller => 'users', :action => 'show_profile', :id => user.id}
  end
  
  def avatar_image_big(user)
    cl_image_tag user.profile_image ? user.profile_image : Chilivote::Application.config.default_profile_image , :width=>168, :height => 168, :crop => :fit, :class => "img-polaroid"
  end
  
  def get_votes_up(contribution_id)
    Like.find_all_by_target_id_and_like_type(contribution_id, Chilivote::Application.config.like_up).count
  end
  
  def get_votes_down(contribution_id)
    Like.find_all_by_target_id_and_like_type(contribution_id, Chilivote::Application.config.like_down).count
  end
  
  def get_cvotes(contribution_id, cvote_id)
    Like.find_all_by_target_id_and_group_id(contribution_id, cvote_id).count
  end
  
  def get_cstatus(user)
    logger = Logger.new('logfile3.log')
    contributions = user.contributions
    up = down = 0
    contributions.each do |contribution|
      up = up + get_votes_up(contribution.id)
      down = down + get_votes_down(contribution.id)
    end
    return up-down
  end
  
  def set_profile_image_variables
    
  end
  
  def get_rank(user)
    Rails.cache.fetch("users_ranks", :expires_in => 5.minutes) do
    #logger = Logger.new('logfile2.log')
    #logger.info "inside the block"
    @users = User.all
    @h = Hash.new
    @users.each do |u|
      @h.store(u.id, get_cstatus(u))
    end
    @sorted_hash = Hash[@h.sort_by{|k, v| v}.reverse]
    @sorted_array = @sorted_hash.keys
  end
    #@rank = @sorted_array.find_index(user.id) + 1
    @rank = Rails.cache.fetch("users_ranks").find_index(user.id)
  
  #attemtping to rescue from nil
  if @rank.nil?
     @users = User.all
    @h = Hash.new
    @users.each do |u|
      @h.store(u.id, get_cstatus(u))
    end
    @sorted_hash = Hash[@h.sort_by{|k, v| v}.reverse]
    @sorted_array = @sorted_hash.keys
    @rank = @sorted_array.find_index(user.id)
    return @rank + 1
  else
    return @rank + 1
  end
  end
end
