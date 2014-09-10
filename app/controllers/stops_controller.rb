class StopsController < ApplicationController



	def index
	end

	def show
		@trip = Trip.find(params[:trip_id])
		@stop = Stop.find(params[:stop_id])

	end

	def new
		@trip = Trip.find(params[:trip_id])
		@trip.find_destination
		@stop = Stop.new

	end

	def create
		@stop = Stop.new(stop_params)
		@trip = Trip.find_by(id: @stop.trip_id)
		if @stop.save
			if params[:commit] == "Add Another"
				redirect_to new_trip_stop_path
			else
				redirect_to trip_path(@trip)
			end 
		else
			render :new
		end
	end

	private
		def stop_params
	    	params.require(:stop).permit(:title, :body, :airport, :location, :airport_pic, :rest, :rest_pic, :hotel, :hotel_pic, :trip_id)
	    end

end
