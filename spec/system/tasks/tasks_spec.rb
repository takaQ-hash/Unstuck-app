require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'タスク一覧' do
    it '登録済みのタスクが一覧に表示されること' do
      create(:task, user: user, name: '一覧確認用タスク')
      visit tasks_path
      expect(page).to have_content('一覧確認用タスク')
    end
  end

  describe 'タスク登録' do
    context '入力情報が正しい場合' do
      it 'タスクが登録できること' do
        visit new_task_path
        expect {
          fill_in 'タスク名', with: '新規タスク'
          fill_in '締切日', with: 1.week.from_now.to_date
          find('input[data-notification-type-target="valueInput"]').set('30')
          click_button '登録'
          expect(page).to have_current_path(tasks_path)
        }.to change(Task, :count).by(1)
        expect(page).to have_content('新規タスク')
      end
    end

    context '入力情報に不備がある場合（タスク名未入力）' do
      it 'タスクが登録できないこと' do
        visit new_task_path
        expect {
          fill_in '締切日', with: 1.week.from_now.to_date
          find('input[data-notification-type-target="valueInput"]').set('30')
          click_button '登録'
        }.not_to change(Task, :count)
        expect(page).to have_content('タスク名を入力してください')
      end
    end
  end

  describe 'タスク詳細' do
    it '登録済みのタスク詳細が表示されること' do
      task = create(:task, user: user, name: '詳細確認用タスク')
      visit task_path(task)
      expect(page).to have_content('詳細確認用タスク')
    end
  end

  describe 'タスク編集' do
    context '入力情報が正しい場合' do
      it 'タスクが編集できること' do
        task = create(:task, user: user, name: '編集前タスク')
        visit edit_task_path(task)
        fill_in 'タスク名', with: '編集後タスク'
        click_button '更新'
        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content('編集後タスク')
      end
    end

    context '入力情報に不備がある場合（タスク名未入力）' do
      it 'タスクが編集できないこと' do
        task = create(:task, user: user, name: '編集前タスク')
        visit edit_task_path(task)
        fill_in 'タスク名', with: ''
        click_button '更新'
        expect(page).to have_content('タスク名を入力してください')
      end
    end
  end

  describe 'タスク削除' do
    it '登録済みのタスクが削除できること' do
      task = create(:task, user: user, name: '削除確認用タスク')
      visit task_path(task)
      expect {
        accept_confirm do
          click_button 'タスク削除'
        end
        expect(page).to have_current_path(tasks_path)
      }.to change(Task, :count).by(-1)
      expect(page).to have_content('タスクを削除しました')
    end
  end
end
