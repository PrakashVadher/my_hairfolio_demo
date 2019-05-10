class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def global
    @user.account_type.eql?('delivery')
  end

  def index?
    global
  end

  def show?
    global
  end

  def update?
    global
  end
end
