class AttachmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    user.try(:is_admin?) || record.ticket.project.has_member?(user)
  end
end
