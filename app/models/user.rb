class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [ :user, :admin ]

  scope :excluding_archived, lambda { where(archived_at: nil) }

  def is_admin?
  	 admin?
  end

  def to_s
  	"#{email} (#{role.titleize})"
  end

  def archive
  	self.update(archived_at: Time.now)
  end
end
