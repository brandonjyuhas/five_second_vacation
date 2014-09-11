require 'spec_helper'

describe User do


	before :each do
		@user = User.new(email: "test@gmail.com", password: "password", password_confirmation: "password")
	end

	describe "user" do
		it "should respond email" do
			expect(@user).to respond_to(:email)
		end
		it "should respond to password" do
			expect(@user).to respond_to(:password)
		end
	end

end