class TripPolicy <  ApplicationPolicy
  def index?
    true
  end

  def account_trips?
    !guest?
  end

  def show?
    true
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
    [:track_id, :dates_range, :end_date, :start_date, :trip_details, :has_guide, :url, :available_places, :menu_id]
  end

  class Scope < Scope
    def resolve
      scope.where user_id: user.id
    end
  end
end
