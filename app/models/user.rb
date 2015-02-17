require 'digest/md5'

class User < ActiveRecord::Base
  ROLE  = [
    ADMIN = 'admin',
    USER = 'user',
    MODERATOR = 'moderator',
    MENU_MODERATOR = 'menu_moderator'
  ]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :trip_comments
  has_one :user_profile
  before_create :update_email_hash
  after_create :set_default_role

  def set_default_role
    if role.blank?
      self.role = USER
      save
    end
  end

  def update_email_hash
    self.email_hash = Digest::MD5.hexdigest(email)
  end

  def can_view_private?(user)
    user.id = id
  end

  def admin?
    roles.include? ADMIN
  end

  def user?
    role? USER
  end

  def moderator?
    role? MODERATOR
  end

  def menu_moderator?
    role? MENU_MODERATOR
  end

  def roles
    @roles ||= role ? role.split(',') : []
  end

  def role?(role_name)
    roles.include? role_name
  end
end
