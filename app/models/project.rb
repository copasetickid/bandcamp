class Project < ActiveRecord::Base
  validates :name, presence: true

  has_many :tickets, dependent: :delete_all
  has_many :roles, dependent: :delete_all

  def has_member?(user)
  	roles.exists?(user_id: user)
  end

  def has_manager?(user)
  	roles.exists?(user_id: user, role: 2)
  end

  def has_editor?(user)
  	roles.exists?(user_id: user, role: 1)
  end

  def has_viewer?(user)
  	roles.exists?(user_id: user, role: 0)
  end
end
