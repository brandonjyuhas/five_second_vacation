class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
    	t.string :location  	
    	t.string :airport
    	t.string :airport_pic
    	t.string :rest
    	t.string :rest_pic
    	t.string :hotel
    	t.string :hotel_pic
    	t.references :trip
      t.string :title
      t.text :body


      t.timestamps
    end
    add_index :stops, :trip_id
  end
end
