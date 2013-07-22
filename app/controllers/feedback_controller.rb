class FeedbackController < ApplicationController
    
    def create
        
        if (feedback_params['rating'] != "|||" or feedback_params['message'] != "")
            @feed = Feedback.new(feedback_params)
            @feed.save!
        end
        
        respond_to do |format|
            format.html {render nothing: true, layout: false}
        end
        
    end
    
        
    private

    
    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
        params.permit(:rating, :message, :user_id)
    end
end
