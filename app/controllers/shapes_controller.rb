class ShapesController < ApplicationController
    before_filter :set_shape, :only => [:save, :destroy, :screenshot]
    skip_before_filter :verify_authenticity_token

  def validUser?
      current_user.id == @shape.user_id
  end
    
  def make_public
      @shape = Shape.find(shape_params[:id])
      @shape.public = 1
      @shape.save!
      respond_to do |format|
          format.html {render nothing: true, layout: false}
      end
  end
    
  def make_product
      
      @shape = Shape.find(shape_params[:id])
      
      if (@shape.name.nil?)
          name = "Untitled #"+shape_params[:id]
      else
          name = @shape.name
      end
      
      @pyt = Spree::Product.create :name => name, :price => @shape.price, :meta_description => @shape.shape, :description => @shape.shape.split("|")[-1], :shipping_category_id => "1"
      
      @pyt.available_on = Time.now
      
      @pyt.images << Spree::Image.create(:attachment => File.open('public/shapes/'+@shape.id.to_s+'.png'))
            
      @pyt.save!
      
      @shape.product_id = @pyt.id
      
      @shape.save!
      
      @response = @pyt.permalink;

      respond_to do |format|
          format.html {render action: 'price', layout: false}
      end
              
      
  end

  def create
      
      apply_this = shape_params.merge({user_id: current_user.id.to_s})

    @shape = Shape.new(apply_this)
      
      logger.info(apply_this)


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
        if @shape.update_attributes(shape_params)
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
          
      respond_to do |format|
          format.html { render nothing: true}
      end
  end
    
  def shapeways_price
      
      require 'oauth'
      require 'net/http'
      
      
      consumer = "4f8ab865d305cc3c72adc687d8c75b2104a6e48d"
      consumer_secret = "9fac7670d859df32e05fe9cc9c7cb85e02de6c64"
      
      @consumer=OAuth::Consumer.new( consumer, consumer_secret, {
                                    site: "http://api.shapeways.com/", request_token_path: "/oauth1/request_token/v1", :http_method        => :post,
                                    :access_token_path  => "/oauth1/access_token/v1"
                                    })
      
      
      @toSend = shape_params['json']      
      
      @access_token = "626a567926d1ab2f9892036459d2720beac690d8"
      @access_token_secret = "904d3556be7f1532efc896e1eb1d7592bb4748a3"
      
      act = OAuth::AccessToken.from_hash(@consumer, {oauth_token: @access_token, oauth_token_secret: @access_token_secret})
      
      res = act.post("/price/v1", @toSend).body
      
      parsed = JSON.parse(res)
      
      @response = parsed['prices'][parsed['prices'].keys[0]]['price']
      
      @response = @response.to_f*1.3
      
      @shape = Shape.find(shape_params[:id])
      @shape.price = @response.round(2)
      
      @shape.save!

      
      
      respond_to do |format|
          format.html {render action: 'price', layout: false}
      end


      
      # Try to find authentication first  end
  end
    
    def resin_price
        
        @shape = Shape.find(shape_params[:id])
        @shape.price = shape_params[:p].to_f.round(2)
        
        @shape.save!
        
        @response = @shape.price
                
        respond_to do |format|
            format.html {render action: 'price', layout: false}
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
      
      @response = price1*1.3
      logger.info(res.body)
      
      
      @shape = Shape.find(shape_params[:id])
      @shape.price = @response.round(2)
      
      @shape.save!
      

      
      respond_to do |format|
          format.html {render layout: false}
      end
      
  end
    
  def fork
      
      @shape = Shape.new(shape_params)
      
      if !user_signed_in?
          format.html {render action: "denied"}
          elsif @shape.save
          system('cp '+ shape_params['id'] + '.png '+ @shape.id+'.png')
          logger.info('\ncp '+ shape_params['id'] + '.png '+ @shape.id+'.png\n')

          format.html { render layout: false}
          format.json { render action: 'show', status: :created, location: @shape }
          else
          format.html { render action: 'new' }
          format.json { render json: @shape.errors, status: :unprocessable_entity }
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
        params.permit(:name, :shape, :user_id, :meta, :authenticity_token, :id, :json, :p, :public)
    end
end
