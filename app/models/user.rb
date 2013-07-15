class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
    devise :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
    has_and_belongs_to_many :spree_roles

    
    attr_accessible :email
    attr_accessible :email, :password, :password_confirmation
    attr_accessible :provider, :uid, :name
    
    

def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
data = access_token.info
user = User.where(:email => data["email"]).first

unless user
    user = User.create(name: data["name"],
                       email: data["email"],
                       password: Devise.friendly_token[0,20]
                       )
end
user
end
    def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
    user = User.create(name:auth.extra.raw_info.name,
    provider:auth.provider,
    uid:auth.uid,
    email:auth.info.email,
    password:Devise.friendly_token[0,20]
    )
end
user
end

def self.new_with_session(params, session)
super.tap do |user|
    if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
    end
end
end
end
