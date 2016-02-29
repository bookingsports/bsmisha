module ApplicationHelper
  def number_to_integer_currency(number)
    number_to_currency number, precision: 0
  end

  def current_user_areas_creation_path
    if current_user.kind_of? StadiumUser
      edit_dashboard_product_path
    elsif current_user.kind_of? CoachUser
      dashboard_employments_path
    end
  end

  def cache_key_for_categories
    count          = Category.count
    max_updated_at = Category.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "categories/all-#{count}-#{max_updated_at}"
  end

  def cache_key_for_stadiums
    count          = Stadium.count
    max_updated_at = Stadium.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "stadiums/all-#{count}-#{max_updated_at}"
  end
end
