=begin disable transfer service temporarly
require "rails_helper"

describe Event::TransferService do
  let!(:stadium) { create(:stadium) }
  let!(:court) { create(:court, stadium: stadium, price: 100, change_price: 10) }
  let!(:event) { create(:event) }
  let!(:special_price) { create(:special_price) }
  let!(:params) { Hash.new }
  let!(:subject) { described_class.new(event, params) }

  before do
    event.product = court
    event.save

    court.special_prices << special_price
    court.save
  end

  describe "#perform" do
    it "should update event attributes" do
      timestamp = Time.zone.now.to_s
      params[:start] = timestamp

      expect {
        subject.perform
      }.to change { event.reload.start.to_date }.to(timestamp.to_date)
    end

    context "when an event has already been tansfered" do
      let!(:event_change) { event.event_changes.create! }

      it "should deny to transfer twice" do
        expect(subject.perform).to eq(false)
      end
    end

    context "when user transfers event for the first time" do
      it "should create event change" do
        expect {
          subject.perform
        }.to change { event.event_changes.count }.by(1)
      end

      context "when user transfers event to more expensive slot" do
        it "should create order" do
          expect {
            subject.perform
          }.to change { Order.count }.by(1)
        end

        it "should count prices difference" do
          Event::TransferService::EventChangeBuilder.any_instance.stub(:new_total).and_return(1500)
          order = Order.create
          event.update_columns(order_id: order.id)

          subject.perform

          expect(subject.event_change_builder.order.reload.total).to eq(500)
        end

        describe "#new_total" do
          let!(:timestamp) { Time.zone.now.beginning_of_year + 36.hours }
          let!(:params) {
            {
              start: timestamp.to_s,
              end: (timestamp + 5.hours).to_s
            }
          }

          it "should count new total correctly" do
            expect(subject.event_change_builder.new_total).to eq(5000)
          end
        end
      end

      context "when user transfers event after 21-00" do
        before do
          Event::TransferService::EventChangeBuilder.any_instance.stub(:over_nine_pm?).and_return(true)
        end

        it "should create order" do
          expect {
            subject.perform
          }.to change { Order.count }.by(1)
        end

        it "should charge additional transfer fee" do
          order = Order.create
          event.update_columns(order_id: order.id)

          subject.perform

          expect(subject.event_change_builder.order.reload.total).to eq(100.0)
        end
      end
    end
  end
end
=end
