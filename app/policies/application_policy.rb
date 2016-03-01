class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user || User.new
    @record = record
  end

  delegate :admin?, to: :user

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

  def multilang?
    admin? || user.moderator?
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

    delegate :admin?, to: :user

    def guest?
      user.new_record?
    end
  end

  protected

  def with_locales(*fields)
    fields.inject([]) do |memo,field|
      memo + I18n.available_locales.map {|locale| "#{field}_#{locale}" } + [ field ]
    end
  end
end
