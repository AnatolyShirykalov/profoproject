class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?
    admin_ui
    can :read, [Photo, Stage, MarkType]
    can :manage, Mark, user: user
    return if user.role != 'admin'
    can :read, :all
    can :manage,:all
    cannot :manage, Mark
  end

  def admin_ui
    can :access, :rails_admin   # grant access to rails_admin
    can :dashboard              # grant access to the dashboard
  end
end
