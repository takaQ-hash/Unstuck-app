require 'rails_helper'

RSpec.describe Report, type: :model do
  context 'ステータス、メモが正しく入力されている場合' do
    it '有効であること' do
      report = build(:report)
      expect(report).to be_valid
    end
  end

  context 'ステータスが存在しない場合' do
    it '無効であること' do
      report = build(:report, status: nil)
      expect(report).to be_invalid
      expect(report.errors[:status]).to include('を入力してください')
    end
  end

  context 'ステータスに未定義の値を指定した場合' do
    it 'ArgumentErrorが発生すること' do
    expect { build(:report, status: 'unknown') }.to raise_error(ArgumentError)
    end
  end

  context 'タスクが削除された場合' do
    it '紐づく報告が削除されること' do
      task = create(:task)
      create(:report, task: task)
      expect { task.destroy! }.to change(Report, :count).by(-1)
    end
  end
end
