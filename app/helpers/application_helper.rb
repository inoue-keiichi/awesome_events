module ApplicationHelper
  def url_for_github(user)
    "http://github.com/#{user.name}"
  end
end
