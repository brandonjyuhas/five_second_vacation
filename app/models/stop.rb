class Stop < ActiveRecord::Base
	attr_accessor :location, :airport_pic
	belongs_to :user

	def initialize
		@location = find_destination
	end



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


	def find_destination

		i = 0
		while true

			@lat = gen_long
			@long = gen_lat

			raw_airport = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@lat},#{@long}&rankby=distance&types=airport&key=#{Rails.application.secrets.google_api_key}")

			break if raw_airport["status"] != "ZERO_RESULTS"
			i += 1
			break if i == 10
		end

		@airport_pic = raw_airport

		# ["name"]["photos"]["photo_reference"]

		raw_rest = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@lat},#{@long}&radius=50000&types=restaurant&key=#{Rails.application.secrets.google_api_key}")

		raw_hotel = HTTParty.get("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@lat},#{@long}&rankby=distance&types=lodging&key=#{Rails.application.secrets.google_api_key}")



		@airport = raw_airport["results"][0]

		if raw_rest["status"] == "ZERO_RESULTS"
			@rest = "Turns out, there was no where to get food anywhere near you. However, you found a few chicken bones, a potatoe, and carrots. Baby, you got a stew going!"
		else
			@rest = raw_rest["results"][0]["name"]
		end

		if raw_hotel["status"] == "ZERO_RESULTS"
			@hotel = ["Unfortunately, there is no lodging near you. You are thrifty, however, and slept outside.","There are no motels in the area! You slept under a tent that you found near a dumpster.","You never made it to the hotel, because you passed out in the airport."].sample
		else
			@hotel = raw_hotel["results"][0]["name"]
		end

		@location = [@airport, @rest, @hotel]

	end



end
