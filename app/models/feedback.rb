class Feedback < ActiveRecord::Base
    attr_accessible :rating, :message, :user_id, :authenticity_token
end
