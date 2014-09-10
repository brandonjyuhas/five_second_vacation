class User < ActiveRecord::Base
	has_many :trips
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    def gravatar_for
		gravatar_id = Digest::MD5::hexdigest(self.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
	end
end
