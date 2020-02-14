class AddBoughtToListings < ActiveRecord::Migration[5.2]
  def change
    add_column :listings, :bought, :boolean, default: false
  end
end
