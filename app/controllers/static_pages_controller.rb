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

class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.friendly.find params[:id]
  end
end
