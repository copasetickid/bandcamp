class Ticket < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :description, length: { minimum: 10 }

  belongs_to :project
  belongs_to :author, class_name: "User"
  belongs_to :state
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  has_many :comments, dependent: :destroy

  before_create :assign_default_state

  private 

  def assign_default_state
  	self.state ||= State.default 
  end
end
