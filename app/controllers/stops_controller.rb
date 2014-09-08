class StopsController < ApplicationController


	def index

	end

	def new
		@stop = Stop.new
	end
end
