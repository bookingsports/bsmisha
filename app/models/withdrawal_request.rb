# == Schema Information
#
# Table name: withdrawal_requests
#
#  id         :integer          not null, primary key
#  wallet_id  :integer
#  status     :integer          default(0)
#  amount     :decimal(8, 2)
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  payment    :text
#

class WithdrawalRequest < ActiveRecord::Base
  include WithdrawalRequestConcern
  has_paper_trail

  belongs_to :wallet
  composed_of :request_data, class_name: "WithdrawalRequestData", mapping: [ %w(id order_id), %w(amount amount)]

  validates :amount, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: Rails.application.secrets.amount_limit }
  validate :amount_no_more_than_can_spend

  after_create :set_payment

  enum status: [:pending, :success, :failure]

  def name
    "Запрос на снятие #{amount} рублей #{wallet_id.present? ? "с кошелька №" + wallet_id.to_s : ""}"
  end

  def set_payment
    account = self.wallet.user.type == "StadiumUser" ? self.wallet.user.stadium.account: self.wallet.user.coach.account
    self.update_attribute('payment',  <<-ENDLINE
1CClientBankExchange
ВерсияФормата=1.02
Кодировка=Windows
Отправитель=Контур.Бухгалтерия
ДатаНачала=#{Time.now.strftime "%d.%m.%Y"}
ДатаКонца=#{Time.now.strftime "%d.%m.%Y"}
РасчСчет=#{Rails.application.secrets.payer_number}
СекцияДокумент=Платежное поручение
Номер=#{self.id}
Дата=#{Time.now.strftime "%d.%m.%Y"}
Сумма=#{self.amount}
ПлательщикСчет=#{Rails.application.secrets.payer_number}
Плательщик=#{Rails.application.secrets.payer_inn} #{Rails.application.secrets.payer_name}
ПлательщикИНН=#{Rails.application.secrets.payer_inn}
ПлательщикКПП=#{Rails.application.secrets.payer_kpp}
Плательщик1=#{Rails.application.secrets.payer_name}
ПлательщикРасчСчет=#{Rails.application.secrets.payer_number}
ПлательщикБанк1=#{Rails.application.secrets.payer_bank1}
ПлательщикБанк2=#{Rails.application.secrets.payer_bank2}
ПлательщикБИК=#{Rails.application.secrets.payer_bik}
ПлательщикКорсчет=#{Rails.application.secrets.payer_korrnumber}
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
НазначениеПлатежа=Оплата по счету № #{self.id} от #{created_at.strftime("%d.%m.%Y")} сумма - #{amount}р. Без НДС.
НазначениеПлатежа1=Оплата по счету № #{self.id} от #{created_at.strftime("%d.%m.%Y")} сумма - #{amount}р. Без НДС.
Очередность=5
КонецДокумента
КонецФайла
ENDLINE
)
  end

  def amount_no_more_than_can_spend
    return if errors.any?
    unless wallet.can_spend? amount
      errors.add :base, "Недостаточно средств"
    end
  end
end
