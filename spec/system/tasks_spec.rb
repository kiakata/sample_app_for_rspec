require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let(:password) { 'password' }
  let(:task) { create(:task, user: user) }

  describe 'ログイン後' do
    before do
      login user, password
    end
    context 'タスクを作成' do
      it '新規作成したタスクが表示される' do
        visit new_task_path
        fill_in 'Title', with: 'test title'
        fill_in 'Content', with: 'test content'
        select 'todo', from: 'Status'
        fill_in 'Deadline', with: Time.new(2019, 02, 21, 10, 11, 12)
        click_button 'Create Task'
        expect(page).to have_content 'Task was successfully created.'
        expect(page).to have_current_path task_path 1
      end
    end

    context 'タスクを編集' do
      it '編集したタスクが表示される' do
        new_title = 'new test title'
        visit edit_task_path task
        fill_in 'Title', with: new_title
        click_button 'Update Task'
        expect(page).to have_content new_title
        expect(page).to have_content 'Task was successfully updated.'
        expect(page).to have_current_path task_path task
      end
    end

    context 'タスクを削除' do
      it 'タスク一覧画面が表示される', js: true do
        task
        expect(Task.count).to eq 1
        visit tasks_path
        click_link 'Destroy', href: task_path(task)
        # page.driver.browser.switch_to.alert.accept
        page.accept_confirm { 'Are you sure?' }
        expect(page).to have_content 'Task was successfully destroyed.'
        expect(Task.count).to eq 0
        expect(page).to have_current_path tasks_path
      end
    end

    context '他のユーザーのtask編集ページを表示' do
      it '他のユーザーのタスクの編集作成ページに遷移できない' do
        another_user_task = another_user.tasks.create(title: 'another title', status: :todo)
        visit edit_task_path another_user_task
        expect(page).to have_content 'Forbidden access'
        expect(page).to have_current_path root_path
      end
    end
  end

  describe 'ログインしていない' do
    context 'タスクを作成' do
      it 'タスクの新規作成ページに遷移できない' do
        visit new_task_path
        expect(page).to have_content 'Login required'
        expect(page).to have_current_path login_path
      end
    end

    context 'タスクを編集' do
      it 'タスクの編集作成ページに遷移できない' do
        visit edit_task_path task
        expect(page).to have_content 'Login required'
        expect(page).to have_current_path login_path
      end
    end
  end
end
