# == Schema Information
#
# Table name: deposit_responses
#
#  id                 :integer          not null, primary key
#  deposit_request_id :integer
#  status             :integer
#  data               :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class DepositResponse < ActiveRecord::Base
  include DepositResponseConcern
  has_paper_trail
  
  belongs_to :deposit_request
  composed_of :response_data, class_name: "DepositResponseData", mapping: %w(data params)
end
