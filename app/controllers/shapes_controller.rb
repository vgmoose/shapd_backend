class ShapesController < ApplicationController
    before_action :set_shape, only: [:save, :destroy, :screenshot]
    
  def validUser?
      current_user.id == @shape['user_id']
  end

  def create
    @shape = Shape.new(shape_params)

    respond_to do |format|
        
      if !user_signed_in?
        format.html {render action: "denied"}
      elsif @shape.save
        format.html { redirect_to @shape, notice: 'Shape was successfully created.' }
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
      
      if validUser?
          File.open(Rails.root.join('public', 'shapes', shape_params[:id]+'.png'), 'wb+') do |file|
              file.write(shape_screen)
          end
      end
          
      respond_to do |format|
          format.html { render nothing: true}
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
        params.permit(:name, :shape, :user_id, :meta, :authenticity_token, :id, :public)
    end
end
