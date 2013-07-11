class Shape < ActiveRecord::Base
    attr_accessible :shape
    attr_accessible :id, :shape, :user_id

end
