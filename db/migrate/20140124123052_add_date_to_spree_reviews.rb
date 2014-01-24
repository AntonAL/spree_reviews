class AddDateToSpreeReviews < ActiveRecord::Migration
  def up
    add_column :spree_reviews, :date, :datetime
  end

  def down
    remove_column :spree_reviews, :date
  end
end
