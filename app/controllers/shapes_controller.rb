class ShapesController < ApplicationController
    before_action :set_shape, only: [:save, :destroy, :screenshot]
    
  def validUser?
      current_user.id == @shape['user_id']
  end

  def create
      logger.info(shape_params)
    @shape = Shape.new(shape_params)

    respond_to do |format|
        
      if !user_signed_in?
        format.html {render action: "denied"}
      elsif @shape.save
          format.html { render layout: false}
        format.json { render action: 'show', status: :created, location: @shape }
      else
        format.html { render action: 'new' }
        format.json { render json: @shape.errors, status: :unprocessable_entity }
      end
    end
  end

  def save
    respond_to do |format|
      if @shape.update(shape_params)
          format.html { render nothing: true, notice: 'Shape was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end
    
  def screenshot
      
      shape_screen = Base64.decode64(shape_params[:meta].gsub('data:image/png;base64,', ''))
      path = Rails.root.join('public', 'shapes', shape_params[:id]+'.png');
      
      if validUser?
          File.open(path, 'wb+') do |file|
              file.write(shape_screen)
          end
      end
      
      system('convert '+path.to_s+' -transparent white '+path.to_s);

          
      respond_to do |format|
          format.html { render nothing: true}
      end
  end
    
  def price
      require 'net/http'
      require 'net/https'
      
      @toSend = shape_params['json']
      
      
      uri = URI.parse("https://i.materialise.com/web-api/pricing")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json', 'Accept' => 'json', 'APICode' => '0FE2EF5F-95E3-4552-B637-55B824E3EF35'})
      req.body = "#{@toSend}"
      res = https.request(req)
      
      parsed = JSON.parse(res.body)
      
      price1 = 0
      #     price2 = 0
      
      # i.materialise parsing
      parsed['models'].each do |s|
      price1 = s['totalPrice'].to_f
      end
      
      #      parsed['shipmentCost']['services'].each do |s|
      #         price2 = s['value'].to_f
      #      end
      
      @response = price1
      #logger.info(@response)
      
      respond_to do |format|
          format.html {render layout: false}
      end
      
  end

  def destroy
      if validUser?
        @shape.destroy
      end
    respond_to do |format|
        format.html { render nothing: true }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shape
      @shape = Shape.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shape_params
        params.permit(:name, :shape, :user_id, :meta, :authenticity_token, :id, :json, :public)
    end
end
