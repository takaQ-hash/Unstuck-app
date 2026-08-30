require 'rails_helper'

RSpec.describe 'Reports', type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user, name: '報告対象タスク') }

  before do
    sign_in user
  end

  describe 'タスク詳細（報告一覧）' do
    it '登録済みの報告がタスク詳細画面に表示されること' do
      create(:report, task: task, memo: '一覧確認用の報告')
      visit task_path(task)
      expect(page).to have_content('一覧確認用の報告')
    end
  end

  describe '報告登録' do
    it '報告が登録できること' do
      visit new_task_report_path(task)
      expect {
        choose '進行中'
        fill_in '一言メモ', with: '新規登録した報告'
        click_button '報告'
        expect(page).to have_current_path(task_path(task))
      }.to change(Report, :count).by(1)
      expect(page).to have_content('新規登録した報告')
    end
  end

  describe '報告編集' do
    it '報告が編集できること' do
      report = create(:report, task: task, memo: '編集前の報告')
      visit edit_task_report_path(task, report)
      fill_in '一言メモ', with: '編集後の報告'
      click_button '更新'
      expect(page).to have_current_path(task_path(task))
      expect(page).to have_content('編集後の報告')
    end
  end

  describe '報告削除' do
    it '登録済みの報告が削除できること' do
        report = create(:report, task: task, memo: '削除確認用の報告')
        visit task_path(task)
        expect {
            accept_confirm do
                click_button '削除'
            end
            expect(page).not_to have_content('削除確認用の報告')
        }.to change(Report, :count).by(-1)
        expect(page).to have_content('報告を削除しました')
    end
  end
end
