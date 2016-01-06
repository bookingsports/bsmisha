class DepositResponse < ActiveRecord::Base
  belongs_to :deposit_request
  composed_of :response_data, class_name: "DepositResponseData", mapping: %w(data params)
end
