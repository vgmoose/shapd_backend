class SplashesController < ApplicationController

    def index
        @splashes = Splash.all
    end

    def create
        
        # Create new Object with email from the form
        @splash = Splash.new({email: splash_params[:email]})
        
        # If the splash doesn't already exist, save it
        if !Splash.where(email: splash_params[:email]).exists?
            @splash.save
        end
            
        # Store a cookie containing the base64 of the email address to the user's computer
        cookies['email_addr'] = {:value => Base64.strict_encode64(splash_params[:email]) , :expires => 1.year.from_now}
            
        # Send the welcome email to the user
        Notifier.welcome(splash_params[:email]);
        
        # Respond with nothing so the form stays on the same page
        respond_to do |format|
            format.js {render :nothing => true}
        end
        
    end
        
    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def splash_params
        params.permit(:email, :utf8, :authenticity_token, :commit)
    end
end
