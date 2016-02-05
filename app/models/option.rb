# == Schema Information
#
# Table name: options
#
#  id             :integer          not null, primary key
#  tax            :integer          default(5)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  feedback_email :string
#

class Option < ActiveRecord::Base
  has_paper_trail
  
  validates :tax, numericality: { greater_than: 0 }

  def self.current
    last || create
  end
end
