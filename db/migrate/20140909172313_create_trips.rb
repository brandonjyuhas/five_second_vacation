class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
    	t.timestamps
    	t.references :user

    end
    add_index :trips, :user_id
  end
end
