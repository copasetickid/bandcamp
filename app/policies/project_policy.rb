class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none if user.nil?
      return scope.all if user.admin?

      scope.joins(:roles).where(roles: { user_id: user })
    end
  end

  def create?
    user.try(:is_admin?)
  end

  def destroy?
    user.try(:is_admin?)
  end

  def show?
    user.try(:is_admin?) || record.has_member?(user)
  end

  def update?
  	user.try(:is_admin?) || record.has_manager?(user)
  end
end
