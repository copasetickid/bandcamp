class TagTicket < ActiveRecord::Base
	belongs_to :tag 
	belongs_to :ticket
end
