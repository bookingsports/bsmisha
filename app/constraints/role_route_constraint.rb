class RoleRouteConstraint
  def initialize(role)
    @role = role
  end

  def matches?(request)
    user = current_user(request)
    user.present? && user.send(@role + "?")
  end

  def current_user request
    request.session["warden.user.user.key"][0][0] && User.find(request.session["warden.user.user.key"][0][0])
  end
end
