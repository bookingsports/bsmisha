# == Schema Information
#
# Table name: withdrawal_requests
#
#  id         :integer          not null, primary key
#  wallet_id  :integer
#  status     :integer
#  amount     :decimal(8, 2)
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WithdrawalRequest < ActiveRecord::Base
  include WithdrawalRequestConcern
  has_paper_trail

  belongs_to :wallet
  composed_of :request_data, class_name: "WithdrawalRequestData", mapping: [ %w(id order_id), %w(amount amount)]

  validate :amount_no_more_than_can_spend

  before_save :set_payment

  enum status: [:pending, :success, :failure]

  def name
    "Запрос на снятие #{amount} рублей #{wallet_id.present? ? "с кошелька №" + wallet_id.to_s : ""}"
  end

  def set_payment
    account = self.wallet.user.account
    self.payment = <<-ENDLINE
1CClientBankExchange
ВерсияФормата=1.02
Кодировка=Windows
Отправитель=Контур.Бухгалтерия
ДатаНачала=#{Time.now.strftime "%d.%m.%Y"}
ДатаКонца=#{Time.now.strftime "%d.%m.%Y"}
РасчСчет=40702810302060000002
СекцияДокумент=Платежное поручение
Номер=#{self.id}
Дата=#{Time.now.strftime "%d.%m.%Y"}
Сумма=#{self.amount}
ПлательщикСчет=40702810302060000002
Плательщик=3662210358 Общество с ограниченной ответственностью "Рэйлсмоб"
ПлательщикИНН=3662210358
ПлательщикКПП=366201001
Плательщик1=Общество с ограниченной ответственностью "Рэйлсмоб"
ПлательщикРасчСчет=40702810302060000002
ПлательщикБанк1=АО "АЛЬФА-БАНК"
ПлательщикБанк2=Г. МОСКВА
ПлательщикБИК=044525593
ПлательщикКорсчет=30101810200000000593
ПолучательСчет=#{account.number}
Получатель=#{account.company}
ПолучательИНН=#{account.inn}
ПолучательКПП=#{account.kpp}
Получатель1=#{account.company}
ПолучательРасчСчет=#{account.number}
ПолучательБанк1=
ПолучательБанк2=
ПолучательБИК=#{account.bik}
ПолучательКорсчет=
ВидПлатежа=
ВидОплаты=01
НазначениеПлатежа=Оплата по счету № 00238 от 10.02.2016г. сумма - 2500р. за подключение к сети интернет и аванс за услуги. В том числе НДС (18%), 381.35 руб.
НазначениеПлатежа1=Оплата по счету № 00238 от 10.02.2016г. сумма - 2500р. за подключение к сети интернет и аванс за услуги. В том числе НДС (18%), 381.35 руб.
Очередность=5
КонецДокумента
КонецФайла
ENDLINE
  end

  def amount_no_more_than_can_spend
    unless wallet.can_spend? amount
      errors.add :base, "Недостаточно средств"
    end
  end
end
