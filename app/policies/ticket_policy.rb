class TicketPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    user.try(:is_admin?) || record.project.roles.exists?(user_id: user)
  end
end
