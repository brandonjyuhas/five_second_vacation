require "net/http"

class Trip < ActiveRecord::Base
	attr_accessor :location, :airport_pic
	belongs_to :user
	has_many :stops


	def gen_long
		num = rand(35_000_000..42_832_000) * 0.000001
		num = '%.5f' % num
		num.to_f
	end

	def gen_lat
		num = rand(-117_218_000..-77_558_000) * 0.000001
		num = '%.5f' % num
		num.to_f
	end

	def gen_long_lat
		location = [gen_long, gen_lat]
	end

	def fetch(uri_str, limit = 10)
	   # You should choose a better exception.
	   raise ArgumentError, 'too many HTTP redirects' if limit == 0

	   response = Net::HTTP.get_response(URI(uri_str))

	   case response
	   when Net::HTTPSuccess then
	     response['location']
	   when Net::HTTPRedirection then
	     location = response['location']
	     warn "redirected to #{location}"
	     return location
	     fetch(location, limit - 1)
	   else
	     response['location']
	   end
	end

	def get_photo(raw_data, data_type)
		if raw_data["results"][0]["photos"] == nil
			if data_type == "restaurant"
				@@rest_array.sample
			else
				@@hotel_array.sample
			end

		else

			@photo_reference = raw_data["results"][0]["photos"][0]["photo_reference"]

			return fetch("https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{@photo_reference}&key=#{Rails.application.secrets.google_api_key}")
		end
	end


	def find_destination

		@@airport_array = ["http://upload.wikimedia.org/wikipedia/commons/9/92/Washington_Dulles_International_Airport_at_Dusk.jpg", "http://www.nykola.com/images/busyairports.jpg","http://www.uniworldnews.org/wp-content/uploads/2013/12/Hong-Kong-International-Airport.jpg","http://www.cleanenergyauthority.com/images/news/201311/charlotte-airport-address.jpg","http://www.best-london-attractions.co.uk/images/AirportsinLondon_opt.jpg","http://www.uniworldnews.org/wp-content/uploads/2013/12/Munich-Airport.jpg","http://upload.wikimedia.org/wikipedia/commons/7/79/Mumbai_Airport.jpg","http://explorestlouis.com/wp-content/uploads/2012/06/C-24-comp.jpg","http://www.prc-magazine.com/wp-content/uploads/2011/10/Flowcrete.jpg","http://www.listverse.info/wp-content/uploads/2013/08/UK-Largest-Airport.jpg","http://upload.wikimedia.org/wikipedia/commons/c/c7/2011-05-09_09-56-33_Switzerland_Kanton_Z%C3%BCrich_Z%C3%BCrich-Kloten_Airport.jpg","http://m2.i.pbase.com/o6/36/640536/1/109654872.aCF7TuTX.010228thFebruary09Terminal3DubaiAirport.jpg","http://2.bp.blogspot.com/-DCQ9BFFUdec/TZx8jQPuFWI/AAAAAAAABBQ/T7vlQ75Xj0E/s1600/Heathrow-Airport-London-4.jpg"]

		@@rest_array = ["http://www.comohotels.com/metropolitanbangkok/sites/default/files/styles/background_image/public/images/background/metbkk_bkg_nahm_restaurant.jpg","http://upload.wikimedia.org/wikipedia/commons/1/1e/Tom's_Restaurant,_NYC.jpg","http://upload.wikimedia.org/wikipedia/commons/7/7f/Hoot1.JPG","https://c1.staticflickr.com/1/109/295646011_ca5bd14ea5_z.jpg?zz=1","https://c2.staticflickr.com/4/3209/2876726449_821eb10b92.jpg","http://pixabay.com/static/uploads/photo/2014/03/25/14/02/restaurant-296225_640.jpg"]

		@@hotel_array = ["http://upload.wikimedia.org/wikipedia/commons/1/17/Hotel_Ritz_Paris.jpg","http://farm9.staticflickr.com/8149/7402778916_423fc9515f_h.jpg","https://c2.staticflickr.com/4/3073/2665413174_f2cea55e07_b.jpg","http://upload.wikimedia.org/wikipedia/commons/7/74/Abandoned_motel,_Pond_Eddy,_NY.jpg","http://upload.wikimedia.org/wikipedia/commons/9/9d/Wigwam_Village_Motel_2000.jpg","https://c2.staticflickr.com/8/7036/6888960537_43382331a3_z.jpg"]

		i = 0
		while true

			@lat = gen_long
			@long = gen_lat

			raw_airport = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@lat},#{@long}&rankby=distance&types=airport&key=#{Rails.application.secrets.google_api_key}")

			break if raw_airport["status"] != "ZERO_RESULTS"
			i += 1
			break if i == 30
		end

		@airport_name = raw_airport["results"][0]["name"]
		@airport_pic = @@airport_array.sample

		raw_rest = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@lat},#{@long}&radius=50000&types=restaurant&key=#{Rails.application.secrets.google_api_key}")


		raw_hotel = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@lat},#{@long}&rankby=distance&types=lodging&key=#{Rails.application.secrets.google_api_key}")

		if raw_rest["status"] == "ZERO_RESULTS"
			@rest_name = "Turns out, there was no where to get food anywhere near you. However, you found a few chicken bones, a potatoe, and carrots. Baby, you got a stew going!"
			@rest_pic = "http://www.therockatbc.com/wp-content/uploads/2012/10/carl-weathers.jpeg"
		else
			@rest_name = raw_rest["results"][0]["name"]
			@rest_pic = get_photo(raw_rest, "restaurant")

		end

		
		if raw_hotel["status"] == "ZERO_RESULTS"
			@hotel_name = ["In Cardboard Box"].sample
			@hotel_pic = "http://www.thebigcritique.com/wp-content/images/television/always_sunny/mac_and_dennis.jpg"
		else
			@hotel_name = raw_hotel["results"][0]["name"]
			@hotel_pic = get_photo(raw_hotel, "hotel")
		end
		
		raw_address = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{@lat},#{@long}&key=#{Rails.application.secrets.google_api_key}")
		unless raw_address["results"][0]["address_components"][3]["short_name"] == "US"

			@address = "#{raw_address["results"][0]["address_components"][3]["short_name"]}, #{raw_address["results"][0]["address_components"][5]["short_name"]}"

		else
			@address = "Nowhere"
		end

	
		@location = [@airport_name, @airport_pic, @rest_name, @rest_pic, @hotel_name, @hotel_pic, @address]

	end

end