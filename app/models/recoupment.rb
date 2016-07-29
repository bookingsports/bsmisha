# == Schema Information
#
# Table name: recoupments
#
#  id         :integer          not null, primary key
#  price      :integer
#  user_id    :integer
#  area_id    :integer
#  reason     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Recoupment < ActiveRecord::Base
  include RecoupmentConcern
  include ActiveModel::Dirty
  has_paper_trail

  belongs_to :user
  belongs_to :area

  validates :user, :price, :area, presence: true
  validates :area_id, uniqueness: { scope: :user_id }
end
