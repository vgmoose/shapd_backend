class Shape < ActiveRecord::Base
    attr_accessible :shape
    attr_accessible :user_id, :shape

end
