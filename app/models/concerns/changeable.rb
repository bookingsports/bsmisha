module Changeable
  extend ActiveSupport::Concern

  included do
    has_many :event_changes, -> { order(created_at: :desc) }, dependent: :destroy

    before_update :break_update, unless: :skip_change_registering?
    after_rollback :create_change, unless: :skip_change_registering?
  end

  def break_update
    @arm_for_change_create = true
    return false
  end

  def create_change
    if @arm_for_change_create
      Rails.logger.debug { "registering change" }
      event_changes.delete_all
      event_changes.create! summary: self.attributes.except("id").to_json, status: :unpaid
      @arm_for_change_create = false
    end
  end

  def skip_change_registering!
    @skip_change_registering = true
  end

  def skip_change_registering?
    unpaid? || @skip_change_registering
  end

  def actual_state
    if event_changes.last.present?
      Event.new JSON.parse(event_changes.last.summary)
    else
      self
    end
  end

  def start
    actual_state.attributes["start"]
  end

  def end
    actual_state.attributes["end"]
  end

  def start_before_change
    attributes["start"]
  end

  def end_before_change
    attributes["end"]
  end

  def start_for user
    if self.user == user
      self.start
    else
      start_before_change
    end
  end

  def end_for user
    if self.user == user
      self.end
    else
      end_before_change
    end
  end

  def has_unpaid_changes?
    event_changes.unpaid.present?
  end

  def event_change
    event_changes.last
  end
end
