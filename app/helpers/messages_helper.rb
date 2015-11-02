module MessagesHelper
  def recipients_options
    s = ''
    current_user.friends.each do |user|
      s << "<option value='#{user.id}'>#{user.first_name}#{" "}#{user.last_name}</option>"
    end
    s << "<option value='#{current_user.id}'>#{current_user.first_name}#{" "}#{current_user.last_name}</option>"
    s.html_safe
  end
end
