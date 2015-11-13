class Ticket < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :description, length: { minimum: 10 }

  belongs_to :project
  belongs_to :author, class_name: "User"
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank

end