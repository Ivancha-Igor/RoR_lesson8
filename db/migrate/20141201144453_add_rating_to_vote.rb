class AddRatingToVote < ActiveRecord::Migration
  def change
    add_column :votes, :rating, :boolean
  end
end
