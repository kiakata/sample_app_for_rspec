require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { FactoryBot.create(:user) }
  context 'with valid attributes' do
    it "is valid with title, text and user_id" do
      task = user.tasks.build(
      title: 'rspec test',
      content: 'test content ...',
      status: 0
      )
      expect(task).to be_valid
    end
  end
  context 'with invalid attributes' do
    it 'is invalid without title' do
      task = user.tasks.build(
      content: 'test content ...',
      status: 0
      )
      expect(task).to be_invalid
      expect(task.errors[:title]).to include("can't be blank")
    end
    it 'is invalid without status' do
      task = user.tasks.build(
      title: 'rspec test',
      content: 'test content ...',
      )
      expect(task).to be_invalid
      expect(task.errors[:status]).to include("can't be blank")
    end
    it 'is invalid with not unique title' do
      task1 = user.tasks.create(
      title: 'same title',
      status: 0
      )
      task2 = user.tasks.build(
      title: 'same title',
      status: 0
      )
      expect(task2).to be_invalid
      expect(task2.errors[:title]).to include('has already been taken')
    end
  end
end
