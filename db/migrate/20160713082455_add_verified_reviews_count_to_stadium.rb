class AddVerifiedReviewsCountToStadium < ActiveRecord::Migration
  def up
    add_column :stadiums, :verified_reviews_counter, :integer, default: 0
    Stadium.all.each { |s| s.update_columns verified_reviews_counter: s.reviews.where(verified: true).count }
  end

  def down
    remove_column :stadiums, :verified_reviews_counter, :integer, default: 0
  end
end
