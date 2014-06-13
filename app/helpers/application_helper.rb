module ApplicationHelper
  def user_avatar(user)
    cl_image_tag user.profile_image ? (user.profile_image) : Chilivote::Application.config.default_profile_image , :width=>40, :height => 40, :crop => :thumb
  end
end
