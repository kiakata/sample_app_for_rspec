require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) {create(:user)}

  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      it 'ログインが成功する' do
        visit login_url
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password'
        click_button 'Login'
        expect(page).to have_content 'Login successful'
        expect(page).to have_current_path(root_path)
      end
    end

    context 'フォームが未入力' do
      it 'ログインが失敗する' do
        visit login_url
        fill_in 'Password', with: 'password'
        click_button 'Login'
        expect(page).to have_content 'Login failed'
        expect(page).to have_current_path(login_path)
      end
    end
  end

  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do
        login user, 'password'
        click_link 'Logout'
        expect(page).to have_content 'Logged out'
        expect(page).to have_current_path(root_path)
      end
    end
  end
end
