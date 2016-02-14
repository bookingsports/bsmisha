class Event::TransferService
  def initialize(event, params = {})
    @event = event
    @params = params
  end

  attr_reader :event, :params

  def perform
    # Перенос конкретного времени может осуществляться только один раз.
    return false if has_already_been_transfered?
    # Когда перенос происходит в первый раз, создаем для него event_change
    event_change_builder.perform

    update_event
  end

  def event_change_builder
    @event_change_builder ||= EventChangeBuilder.new(event, params)
  end

  def update_event
    event.update(params)
  end

  def has_already_been_transfered?
    event.event_changes.present?
  end

  class EventChangeBuilder
    def initialize(event, params)
      @event = event
      @params = OpenStruct.new(params)
    end

    attr_reader :event, :params

    def perform
      event_change.save
      # Перенос должен работать только в одном направлении: если перенос идет на
      # более дешевое время, то деньги клиенту не возвращаются. Если перенос
      # идет на более дорогое время, то создаем заказ с разницей стоимости.
      handle_transfer_price_diff if new_price_is_higher?
      # Перенос может осуществляться бесплатно накануне до 21.00!
      # После 21.00 перенос производится с комиссией клубу
      handle_transfer_time if over_nine_pm?

      order.save
    end

    def event_change
      @event_change ||= event.event_changes.build
    end

    def order
      @order ||= event_change.build_order(total: 0, comment: event_change.name)
    end

    def handle_transfer_price_diff
      order.total += new_total - event.total
    end

    def new_price_is_higher?
      if court.special_prices.any?
        event.total < new_total
      else
        # Если у корта нет специальных цен, подразумевается, что цена на весь
        # день одна и та же, равная цене корта
        false
      end
    end

    def handle_transfer_time
      transfer_percent = court.try(:change_price)
      total = event.order.try(:total)
      # Комиссия клубу считается от общей стоимости уже созданного заказа
      order.total += total*transfer_percent/100 if total
    end

    # Московское время
    def over_nine_pm?
      Time.zone.now > Time.zone.parse("21:00")
    end

    def new_total
      return 0 if new_start.blank? || new_end.blank?
      return @new_total unless @new_total.blank?

      old_start, old_end = event.start, event.end
      event.start, event.end = new_start, new_end

      @new_total = event.total

      event.start, event.end = old_start, old_end

      @new_total
    end

    def related_special_price
      @related_special_price ||= begin
        court.special_prices.to_a.detect do |special_price|
          (special_price.start <= new_start && special_price.stop >= new_start) ||
          (special_price.start <= new_end && special_price.stop >= new_end)
        end
      end
    end

    def new_start
      @new_start ||= Time.zone.parse(params.start) if params.start
    end

    def new_end
      @new_end ||= Time.zone.parse(params.end) if params.end
    end

    def court
      @court ||= event.court
    end
  end
end
