require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

  context 'with valid attributes' do
    it "is valid with title, text and user_id" do
      expect(task).to be_valid
    end
  end

  context 'with invalid attributes' do
    it 'is invalid without title' do
      task.title = nil
      expect(task).to be_invalid
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without status' do
      task.status = nil
      expect(task).to be_invalid
      expect(task.errors[:status]).to include("can't be blank")
    end

    it 'is invalid with not unique title' do
      task.save
      same_title_task = task.user.tasks.build(
        title: task.title
      )
      expect(same_title_task).to be_invalid
      expect(same_title_task.errors[:title]).to include('has already been taken')
    end
  end
end
