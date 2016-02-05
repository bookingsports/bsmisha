# == Schema Information
#
# Table name: static_pages
#
#  id         :integer          not null, primary key
#  text       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#

require 'rails_helper'

RSpec.describe StaticPage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
