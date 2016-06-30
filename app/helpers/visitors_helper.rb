module VisitorsHelper
  def stadium_infowindow(stadium)
    result = "#{stadium.name}<br>#{stadium.phone}"
    if stadium.active?
      result += " #{link_to 'Перейти на страницу', Rails.application.routes.url_helpers.stadium_path(stadium)}"
    end
    return result
  end

  def stadium_get_category_icon(stadium)
    if stadium.active? || stadium.pending?
      stadium.category.icon.present? ? stadium.category.icon.thumb.url : "gray-icon.png"
    elsif stadium.locked?
      "gray-icon.png"
    end
  end
end
