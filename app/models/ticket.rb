class Ticket < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :description, length: { minimum: 10 }

  belongs_to :project
  belongs_to :author, class_name: "User"

  mount_uploader :attachment, AttachmentUploader
end
