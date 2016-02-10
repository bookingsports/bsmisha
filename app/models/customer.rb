# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string
#  role                   :integer
#  type                   :string
#  slug                   :string
#  avatar                 :string
#  status                 :integer
#  phone                  :string
#

class Customer < User
  include CustomerConcern
  
  def products
    Product.where(id: events.map(&:product_ids).flatten)
  end
end
