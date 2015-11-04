class TicketPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    user.try(:is_admin?) || record.project.has_member?(user)
  end

  def create?
  	user.try(:is_admin?) || record.project.has_manager?(user) || record.project.has_editor?(user)
  end
end
