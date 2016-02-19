module ApplicationHelper
  def number_to_integer_currency(number)
    number_to_currency number, precision: 0
  end

  def current_user_courts_creation_path
    if current_user.kind_of? StadiumUser
      edit_dashboard_product_path
    elsif current_user.kind_of? CoachUser
      dashboard_employments_path
    end
  end
end
