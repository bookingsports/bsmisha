class OrderItem
  has_paper_trail
  
  def initialize(attributes)
    @start = attributes[:start]
    @end = attributes[:end]
    @court = attributes[:court]
  end
end