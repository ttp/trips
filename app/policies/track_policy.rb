class TrackPolicy <  ApplicationPolicy
  def index?
    true
  end

  def account_tracks?
    !guest?
  end

  def create?
    !guest?
  end

  def update?
    admin? || owner?
  end

  def destroy?
    admin? || owner?
  end

  def permitted_attributes
    [:name, :region_id, :description, :url, :track]
  end

  class Scope < Scope
    def resolve
      scope.where user_id: user.id
    end
  end
end
