class CoachesCourt < ActiveRecord::Base
  belongs_to :coach
  belongs_to :court

  delegate :name, :stadium, :events, to: :court
end
