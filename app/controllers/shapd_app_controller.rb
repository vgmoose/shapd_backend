class ShapdAppController < ApplicationController
    def index

        if (params[:a] != nil && params[:a] != "")
            decrypted_email = Base64.decode64(params[:a])
        else
            decrypted_email = "???_???"
        end
            
        if Splash.where(email: decrypted_email).exists?
            respond_to(:html)
        elsif cookies['email_addr'] != params[:a] and !cookies['email_addr'].nil?
            redirect_to '/demo/?a='+cookies['email_addr']
        else
            redirect_to '/'
        end
    end
    
    def edit
        @shape = Shape.find(params[:id])
        
        if (@shape[:user_id] == current_user[:id])
            logger.info("good!")
        else
            logger.info("bad...")
        end
        
    end
    

end
