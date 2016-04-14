class TicketPdf < Prawn::Document
  def initialize event, view
    super()
    @event = event

    font_families.update(
      "Verdana" => {
        :bold => "vendor/assets/fonts/verdanab.ttf",
        :italic => "vendor/assets/fonts/verdanai.ttf",
        :normal  => "vendor/assets/fonts/verdana.ttf" })
    font 'Verdana', size: 15

    move_down 40
    text "Спасибо за ваш заказ, #{@event.user.name}!"
    move_down 5
    text 'Пожалуйста, распечатайте этот талон как подтверждение вашего заказа.'

    if @event.recurring?
      table([
        ['Стадион', @event.area.stadium.name],
        ['Имя', @event.user.name],
        ['Площадка', @event.area.stadium.category.name],
        ['Категория', @event.area.name],
        ['Количество повторений', @event.occurrences.to_s]
                ])

      move_down 20
      print_occurrences
    else
      table([
        ['Стадион', @event.area.stadium.name],
        ['Имя', @event.user.name],
        ['Площадка', @event.area.stadium.category.name],
        ['Категория', @event.area.name],
        ['Начало', @event.start.to_s],
        ['Конец', @event.stop.to_s]
          ])
    end

    move_down 20
    text 'Стоимость:', style: :bold
    text @event.price.to_s + ' руб.'
    table([
        ["Стоимость площадки", @event.area_price.to_s + " руб."],
        ["Стоимость тренера", @event.coach_price.to_s + " руб."],
        ["Стоимость услуг", @event.stadium_services_price.to_s + " руб."]
      ])
    move_down 20

    if @event.coach.present?
      text 'Тренер:', style: :bold
      text @event.coach.name
    end
    print_stadium_services
  end

  def print_stadium_services
    if @event.stadium_services.present?
      text 'Услуги:', style: :bold
      table(@event.stadium_services.each.map{|ss| [ss.service.name, ss.price.to_s + " руб."]})
    end
  end

  def print_occurrences
    if @event.recurring?
      text 'Повторения:', style: :bold
      table(@event.all_occurrences.each.map{|o| [o.to_date, o.strftime("%H:%M"), (o + @event.duration).strftime("%H:%M")]})
    end
  end
end