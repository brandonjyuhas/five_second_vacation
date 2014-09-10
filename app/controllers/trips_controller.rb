class TripsController < ApplicationController
	before_action :authenticate_user!, only: [:edit, :create, :update, :destroy]

	def index
		@trips = Trip.all
	end

	def show
		@trip = Trip.find(params[:id])
		@stops = @trip.stops
	end

	def new
		@trip = Trip.new
	end

	def create
		@trip = Trip.new
		@trip.user_id = current_user.id
		@trip.save
		redirect_to new_trip_stop_path(@trip)
	end

	
end