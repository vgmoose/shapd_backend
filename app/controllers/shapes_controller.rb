class ShapesController < ApplicationController
  before_action :set_shape, only: [:save, :destroy]
    
  def validUser(id)
      current_user.id == id
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

  def destroy
    @shape.destroy
    respond_to do |format|
      format.html { redirect_to shapes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shape
      @shape = Shape.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shape_params
      params.permit(:name, :shape, :user_id, :public)
    end
end
