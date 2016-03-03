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

require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }

  context 'associations' do
    it { should have_many(:orders).dependent(:destroy) }
    it { should have_many(:events).dependent(:destroy) }
    it { should have_one(:wallet).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }

    context 'name' do
      it 'should not validate empty name' do
        expect(build(:user, name: nil)).not_to be_valid
      end

      it 'should not validate garbage name' do
        expect(build(:user, name: "23#@$@*@%")).not_to be_valid
      end

      it 'should validate regular name' do
        expect(build(:user, name: "John Smith")).to be_valid
      end
    end
  end

  context "methods" do
    describe '#type' do
      it "is set to Customer by default" do
        user = User.new
        expect(user.type).to eq "Customer"
      end
    end

    describe "#wallet" do
      it "is created on initialize" do
        expect(user.wallet).not_to be_nil
      end
    end

    describe "#admin?" do
      it "is returning false" do
        expect(user.admin?).to eq false
      end
    end

    describe "#total" do
      it "returns proper amount" do
        event = create(:event)
        user.events << event
        expect(user.total).to eq event.area.price * event.duration_in_hours
      end
    end

    describe "#total_hours" do
      it "returns proper amount when events are present" do
        @event = create(:event)
        user.events << @event
        expect(user.total_hours).to eq @event.duration_in_hours
      end

      it "returns 0 when events are not present" do
        expect(user.total_hours).to eq 0
      end
    end


    describe "#name_for_admin" do
      it "should return proper name" do
        @user = build(:user, name: "John Smith", email: "user@mail.ru")
        expect(@user.name_for_admin).to eq "John Smith (user@mail.ru)"
      end
    end
  end
end

RSpec.describe Customer do
  let(:customer) { create(:customer) }
  context 'methods' do
    describe '#admin?' do
      it "should return false" do
        expect(customer.admin?).to eq false
      end
    end

    describe "#areas" do
      it "should return areas customer booked" do
        @event = create(:event)
        customer.events << @event
        expect(customer.areas).to include @event.area
      end

      it "should not include areas customer didn't book" do
        @area = create(:area)
        expect(customer.areas).not_to include @area
      end
    end

    describe "#events" do
      it "should return events of customer" do
        @event = create(:event)
        customer.events << @event
        expect(customer.events).to include @event
      end

      it "should not include events of other user" do
        @another_customer = create(:customer)
        @event = create(:event)
        @another_customer.events << @event
        expect(customer.events).not_to include @event
      end
    end
  end
end

RSpec.describe StadiumUser do
  let(:stadium_user) { create(:stadium_user) }
  let(:stadium) { stadium_user.stadium }

  context 'methods' do
    describe '#admin?' do
      it "should return false" do
        expect(stadium_user.admin?).to eq false
      end
    end

    describe "#areas" do
      it "should return stadium's areas" do
        area = create(:area)
        stadium.areas << area
        expect(stadium_user.areas).to include area
      end

      it "should not include another stadium's areas" do
        area = create(:area)
        another_stadium_user = create(:stadium_user)
        another_stadium_user.stadium.areas << area
        expect(stadium_user.areas).not_to include area
      end
    end

    describe "#stadium_events" do
      it "should return events of stadium's areas" do
        event = create(:event, area: stadium_user.areas.first)
        expect(stadium_user.stadium_events).to include event
      end

      it "should not include events of other stadium" do
        another_stadium_user = create(:stadium_user)
        event = create(:event, area: another_stadium_user.areas.first)
        another_stadium_user.events << event
        expect(stadium_user.stadium_events).not_to include event
      end
    end
  end
end

RSpec.describe Admin do
  let(:admin) { create(:admin) }

  context 'methods' do
    describe '#admin?' do
      it "should return true" do
        expect(admin.admin?).to eq true
      end
    end
  end
end