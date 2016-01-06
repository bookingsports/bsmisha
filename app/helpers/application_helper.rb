module ApplicationHelper
  def number_to_integer_currency(number)
    number_to_currency number, precision: 0
  end

  def stadium_infowindow(stadium)
    result = "#{stadium.name}<br>#{stadium.phone}"
    if stadium.active?
      result += " #{link_to 'Перейти на страницу', stadium}"
    end
    return result
  end

  def stadium_get_category_icon(stadium)
    if stadium.active?
      stadium.category.try(:icon)
    elsif stadium.locked?
      "gray-icon.png"
    end
  end

  def current_user_courts_creation_path
    if current_user.kind_of? StadiumUser
      edit_dashboard_product_path
    elsif current_user.kind_of? CoachUser
      dashboard_employments_path
    end
  end
end
