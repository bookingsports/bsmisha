class TicketPdf < Prawn::Document
  def initialize event, view
    super()
    @event = event

    font_families.update(
      "Verdana" => {
        :bold => "vendor/assets/fonts/verdanab.ttf",
        :italic => "vendor/assets/fonts/verdanai.ttf",
        :normal  => "vendor/assets/fonts/verdana.ttf" })
    font 'Verdana', size: 10

    move_down 40
    text "Спасибо за ваш заказ, #{@event.user.name}!"
    move_down 5
    text 'Пожалуйста, распечатайте этот талон как подтверждение вашего заказа.'

    move_down 20
    text 'Подробности:', style: :bold
    move_down 10
    text 'Стадион:', style: :bold
    text @event.area.stadium.name
    text 'Площадка:', style: :bold
    text @event.area.name
    text 'Начало:', style: :bold
    text @event.start.to_s
    text 'Конец:', style: :bold
    text @event.stop.to_s
    text 'Стоимость:', style: :bold
    text @event.price.to_s + ' руб.'
    if @event.coach.present?
      text 'Тренер:', style: :bold
      text @event.coach.name
    end
    print_stadium_services
  end

  def print_stadium_services
    if @event.stadium_services.present?
      text 'Услуги:', style: :bold
      data = []
      @event.stadium_services.each do |ss|
        text ss.service_name_and_price
      end
    end
  end
end