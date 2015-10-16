module ApplicationHelper
	def title(*parts)
		unless parts.empty?
			content_for :title do 
				(parts << "Bandcamp").join(" - ")
			end
		end
	end
end
