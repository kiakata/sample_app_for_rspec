module AuthenticationForFeatureRequest
  # def login user, password = 'login'
  #   user.update_attributes password: password

  #   page.driver.post login_url, {email: user.email, password: password}
  #   visit root_url
  # end

  def login user, password
    visit login_url
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Login'
    visit root_url
  end
end
