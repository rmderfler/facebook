module ApplicationHelper

  def can_display_status?(message)
    signed_in? && !current_user.has_blocked?(message.user) || !signed_in?
  end

  def flash_class(type)
    case type
    when 'alert'
      "alert-warning"
    when 'notice'
      "alert-success"
    else
      ""
    end
  end
end
