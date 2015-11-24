class Ticket < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :description, length: { minimum: 10 }

  belongs_to :project
  belongs_to :author, class_name: "User"
  belongs_to :state

  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
  has_many :comments, dependent: :destroy
  has_many :tag_tickets
  has_many :tags, :through => :tag_tickets
  has_many :ticket_watchers
  has_many :watchers, :through => :ticket_watchers, source: :user

  before_create :assign_default_state
  after_create :author_watches_me

  attr_accessor :tag_names

  def tag_names=(names)
    @tag_names = names
    names.split.each do |name|
      self.tags << Tag.find_or_initialize_by(name: name)
    end
  end

  private

  def assign_default_state
  	self.state ||= State.default
  end

  def author_watches_me
    if author.present? && !self.watchers.include?(author)
      self.watchers << author
    end
  end
end
