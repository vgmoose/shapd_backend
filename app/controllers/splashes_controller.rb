class SplashesController < ApplicationController
    before_action :set_splash, only: [:show, :edit, :update, :destroy]
    # GET /splashes
    # GET /splashes.json
    def index
        @splashes = Splash.all
    end
    
    # GET /splashes/1
    # GET /splashes/1.json
    def show
    end
    
    # GET /splashes/new
    def new
        @splash = Splash.new
    end
    
    # GET /splashes/1/edit
    def edit
    end
    
    def welcome(recipient)
        Notifier.welcome(recipient).deliver # sends the email
    end
    
    # POST /splashes
    # POST /splashes.json
    def create
        
        @splash = Splash.new(splash_params)
        cookies['email_addr'] = {:value => splash_params[:email] , :expires => 1.year.from_now}
        welcome(splash_params[:email]);
        
        
        respond_to do |format|
            if @splash.save
                format.html {  render action: 'new'  }
                format.json { render action: 'show', status: :created, location: @splash }
                else
                format.html { render action: 'new' }
                format.json { render json: @splash.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # PATCH/PUT /splashes/1
    # PATCH/PUT /splashes/1.json
    def update
        respond_to do |format|
            if @splash.update(splash_params)
                format.html { redirect_to @splash, notice: 'Splash was successfully updated.' }
                format.json { head :no_content }
                else
                format.html { render action: 'edit' }
                format.json { render json: @splash.errors, status: :unprocessable_entity }
            end
        end
    end
    
    # DELETE /splashes/1
    # DELETE /splashes/1.json
    def destroy
        @splash.destroy
        respond_to do |format|
            format.html { redirect_to splashes_url }
            format.json { head :no_content }
        end
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_splash
        @splash = Splash.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def splash_params
        params.permit(:email)
    end
end
