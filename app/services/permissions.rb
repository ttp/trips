module Permissions
  class Acl
    def initialize(user)
      @user = user || User.new
    end

    def for_resource(resource)
      @permissions ||= {}
      @permissions[resource] ||= "Permissions::#{resource}Permissions".constantize.new(@user)
    end
  end

  class BasePermissions
    def initialize(user)
      @user = user
      @allowed = {}
      init_permissions
    end

    def allow(action, &block)
      @allowed[action] = block || true
    end

    def allowed?(action, instance = nil)
      return true if @user.admin?
      @allowed[action] && (@allowed[action] == true || instance && @allowed[action].call(instance))
    end

    def init_permissions
    end
  end

  class UserResourcePermissions < BasePermissions
    def init_permissions
      allow 'edit' do |resource| !resource.user_id.nil? && resource.user_id  == @user.id end
    end
  end

  class MenuPermissions < UserResourcePermissions
    def init_permissions
      super

      if @user.role? User::USER
        init_user
      elsif @user.role?(User::MENU_MODERATOR) || @user.role?(User::MODERATOR)
        init_moderator
      end
    end

    def init_user
      allow 'create'
    end

    def init_moderator
      allow 'create'
      allow 'edit'
      allow 'moderate'
    end
  end
end
