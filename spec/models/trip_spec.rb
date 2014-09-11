require "spec_helper"

describe Trip do  
	
	before :each do
	    @trip = Trip.new
	end

	describe "#gen_long" do
		it "returns a float" do
			expect(@trip.gen_long).to be_kind_of(Float)
		end
		it "should return a number between " do
			expect(@trip.gen_long).to be_between(35,43).inclusive
		end
	end

	describe "#gen_lat" do
		it "returns a float" do
			expect(@trip.gen_lat).to be_kind_of(Float)
		end
		it "should return a number between " do
			expect(@trip.gen_lat).to be_between(-117,-77)
		end
	end
end