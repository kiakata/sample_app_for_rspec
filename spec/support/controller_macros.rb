module ControllerMacros
  def login(user)
    login(user.email, user.password)
  end
end
