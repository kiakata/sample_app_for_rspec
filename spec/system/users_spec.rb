require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let(:password) { 'password' }
  before do
    driven_by(:rack_test)
  end
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成ができる' do
          visit root_path
          click_link 'SignUp'
          fill_in 'Email', with: 'test@test.com'
          fill_in 'Password', with: password
          fill_in 'Password confirmation', with: password
          click_button 'SignUp'
          expect(page).to have_content 'User was successfully created.'
          expect(page).to have_current_path login_path
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit root_path
          click_link 'SignUp'
          fill_in 'Password', with: password
          fill_in 'Password confirmation', with: password
          click_button 'SignUp'
          expect(page).to have_content "Email can't be blank"
          expect(page).to have_current_path users_path
        end
      end

      context '登録済メールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          visit root_path
          click_link 'SignUp'
          fill_in 'Email', with: user.email
          fill_in 'Password', with: password
          fill_in 'Password confirmation', with: password
          click_button 'SignUp'
          expect(page).to have_content 'Email has already been taken'
          expect(page).to have_current_path users_path
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(user)
          expect(page).to have_content 'Login required'
          expect(page).to have_current_path login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before do
      login user, password
    end
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集ができる' do
          visit edit_user_path user
          fill_in 'Email', with: 'new_address@test.com'
          fill_in 'Password', with: password
          fill_in 'Password confirmation', with: password
          click_button 'Update'
          expect(page).to have_content 'User was successfully updated.'
          expect(page).to have_current_path user_path user
        end
      end
    end

    context 'メールアドレスが未入力時に' do
      it 'ユーザーの編集が失敗する' do
        visit edit_user_path user
        fill_in 'Email', with: ''
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: password
        click_button 'Update'
        expect(page).to have_content "Email can't be blank"
        expect(page).to have_current_path user_path user
      end
    end
    context '登録済メールアドレスを使用' do
      it 'ユーザーの編集が失敗' do
        visit edit_user_path user
        fill_in 'Email', with: another_user.email
        fill_in 'Password', with: password
        fill_in 'Password confirmation', with: password
        click_button 'Update'
        expect(page).to have_content 'Email has already been taken'
        expect(page).to have_current_path user_path user
      end
    end
    context '他ユーザーの編集ページにアクセス' do
      it 'アクセスが失敗する' do
        visit edit_user_path another_user
        expect(page).to have_content 'Forbidden access.'
        expect(page).to have_current_path user_path user
      end
    end
  end

  describe 'マイページ' do
    context 'タスクを作成' do
      it '新規作成したタスクが表示される' do
        task_title = 'test title'
        login user, password
        visit new_task_path
        fill_in 'Title', with: task_title
        fill_in 'Content', with: 'test content'
        select 'todo', from: 'Status'
        fill_in 'Deadline', with: '2019/11/16 00:00'
        click_button 'Create Task'
        expect(page).to have_content 'Task was successfully created.'
        expect(page).to have_current_path task_path 1
        visit user_path user
        expect(first('td')).to have_content task_title
      end
    end
  end
end
