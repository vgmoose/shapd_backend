class ShapdAppController < ApplicationController
    def index

        # if there are arguments in the URL, decode them
        if (params[:a] != nil && params[:a] != "")
            decrypted_email = Base64.decode64(params[:a])
        else
            decrypted_email = ""
        end
                
        # check if they have an account
        if user_signed_in?
            if (params[:a] == nil)
                respond_to do |format|
                    format.html {render layout: "create_loader"}
                end
            else
                redirect_to '/demo/'
            end
        
        # check if the decoded email from the URL is in the database
        elsif Splash.where(email: decrypted_email).exists? and decrypted_email != ""
            respond_to do |format|
                format.html {render layout: "create_loader"}
            end
            
        # if not, perhaps their email cookie will be in the database
        elsif cookies['email_addr'] != params[:a] and !cookies['email_addr'].nil?
            redirect_to '/demo/?a='+cookies['email_addr']
            
        # it wasn't
        else
            respond_to do |format|
                # normally the denial would go here
                format.html {render layout: "create_loader"}
            end
        end
        
    end
    
    def feedback
        
    end
    
    def login
        
    end
    
    def resp
        respond_to do |format|
            format.html {render action: "response"}
        end
    end
    
    def edit
        
        # check if viewer mode is on
        if (!params[:view].nil?)
            @view = true
        end
        
        if (!params[:print].nil? and !current_user[:admin].nil?)
            @admin = true
        end
        
        # find the shape id from URL
        @shape = Shape.find(params[:id])
        
        # if a user is logged in, and their user_id matches the shape's owner
        if ((!current_user.nil? and @shape[:user_id] == current_user[:id]) or (((defined? @view) or (!params[:meta].nil?)) and @shape.public==1) or !@admin.nil?)
            respond_to do |format|
                # deny access if those conditions aren't met
                format.html {render action: "index", layout: "create_loader"}
            end
        else
            respond_to do |format|
                # deny access if those conditions aren't met
                format.html {render action: "denied"}
            end
        end
        
    end
    

end
