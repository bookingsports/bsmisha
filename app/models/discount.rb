class Discount < ActiveRecord::Base
  include DiscountConcern
  has_paper_trail

  belongs_to :user, required: true
  belongs_to :area, required: true
end
