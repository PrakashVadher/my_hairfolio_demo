class SalonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    @user&.id == @record.owner&.id
  end
end
