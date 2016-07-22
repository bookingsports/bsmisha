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
#  name                   :string
#  type                   :string           default("Customer")
#  avatar                 :string
#  phone                  :string
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ActiveRecord::Base
  has_paper_trail

  include PapertrailStiFixConcern
  include UserConcern

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :orders, dependent: :destroy
  has_many :events, dependent: :destroy

  has_many :event_changes, through: :events, dependent: :destroy
  has_many :recoupments, dependent: :destroy

  has_one :wallet, dependent: :destroy
  accepts_nested_attributes_for :wallet

  validates :name, presence: true
  validates_format_of :name, :with => /[\p{L} ]/
  validates :phone, presence: true
  validates_format_of :phone, with: /\+[0-9] \([0-9]{3}\) [0-9]{3}-[0-9]{2}-[0-9]{2}/

  after_create :create_wallet

  validates_acceptance_of :terms_agree

  mount_uploader :avatar, PictureUploader

  default_scope -> { order(created_at: :desc) }

  def total(options = {})
    events_maybe_scoped_by(options).unpaid.unconfirmed.future.map(&:price).inject(:+) || 0
  end

  def total_hours(options = {})
    events_maybe_scoped_by(options).unpaid.unconfirmed.future.map{|e| e.duration_in_hours * e.occurrences}.inject(:+) || 0
  end

  def total_recoupments(area = {})
    recoupments.where(area: area[:area]).map(&:price).inject(:+) || 0
  end

  def events_maybe_scoped_by options
    if options[:area].present? && options[:coach_id].present?
      events.where(area: options[:area]).where(coach_id: options[:coach_id])
    elsif options[:area].present?
      events.where(area: options[:area])
    else
      events
    end
  end

  def changes_total(options = {})
    event_changes.unpaid.future.map(&:total).inject(:+) || 0
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
end
