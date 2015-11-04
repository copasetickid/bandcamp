class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  enum role: [ :viewer, :editor, :manager ]

  def self.available_roles
  	%w(manager, editor, viewer)
  end
end
