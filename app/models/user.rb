class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders, dependent: :destroy
  has_many :events
  has_many :event_changes, through: :events
  has_one :wallet, dependent: :destroy
  has_many :special_prices
  after_create :create_wallet

  after_initialize :set_customer, if: :new_record?

  validates_acceptance_of :terms_agree

  default_scope -> { order(created_at: :desc) }

  def set_customer
    self.type = "Customer" unless self.type
  end

  def public_type= type
    if type == "Admin"
      raise "Нельзя стать админом просто так!"
    elsif ["StadiumUser", "CoachUser", "Customer"].include? type
      self.becomes! type.constantize
    end
  end

  def total(options = {})
    events_maybe_scoped_by(options).unpaid.map(&:total).inject(:+)
  end

  def total_hours(options = {})
    events_maybe_scoped_by(options).unpaid.map(&:duration_in_hours).inject(:+) || 0
  end

  def events_maybe_scoped_by options
    if options[:product].present?
      events.of_products(options[:product])
    else
      events
    end
  end

  def changes_total(options = {})
    event_changes.of_products(options[:product]).unpaid.map(&:total).inject(:+) || 0
  end

  def navs
    []
  end

  def method_missing(t)
    if t.to_s.ends_with? "?"
      type == t.to_s.to(-2).camelcase
    end
  end

  def name_for_admin
    name.to_s + " (#{email})"
  end

  def admin?
    false
  end

  def new_event(options = {})
    self.events.new options
  end
end
