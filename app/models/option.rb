class Option < ActiveRecord::Base
  validates :tax, numericality: { greater_than: 0 }

  def self.current
    last || create
  end
end
