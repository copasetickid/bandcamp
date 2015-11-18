class Tag < ActiveRecord::Base
	has_many :tag_tickets
	has_many :tickets, :through => :tag_tickets
end
