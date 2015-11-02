class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  enum role: [ :viewer, :editor, :manager ]
end
