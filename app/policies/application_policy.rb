class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user || User.new
    @record = record
  end

  def admin?
    user.admin?
  end

  def guest?
    user.new_record?
  end

  def owner?
    record.user_id.present? && record.user_id == user.id
  end

  def index?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
  end

  def new?
    create?
  end

  def update?
    admin?
  end

  def edit?
    update?
  end

  def destroy?
    admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user || User.new
      @scope = scope
    end

    def resolve
      scope
    end

    def admin?
      user.admin?
    end

    def guest?
      user.new_record?
    end
  end
end

