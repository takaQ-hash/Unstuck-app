require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'タスク名、締切日、通知タイプ、通知時間が正しく設定されている場合' do
    it '有効であること' do
      task = build(:task)
      expect(task).to be_valid
    end
  end

  context 'タスク名が存在しない場合' do
    it '無効であること' do
      task = build(:task, name: nil)
      expect(task).to be_invalid
      expect(task.errors[:name]).to include('を入力してください')
    end
  end

  context '締切日が存在しない場合' do
    it '無効であること' do
      task = build(:task, deadline: nil)
      expect(task).to be_invalid
      expect(task.errors[:deadline]).to include('を入力してください')
    end
  end

  context '通知タイプが存在しない場合' do
    it '無効であること' do
      task = build(:task, notification_type: nil)
      expect(task).to be_invalid
      expect(task.errors[:notification_type]).to include('を入力してください')
    end
  end

  context '通知時間が存在しない場合' do
    it '無効であること' do
      task = build(:task, notification_value: nil)
      expect(task).to be_invalid
      expect(task.errors[:notification_value]).to include('を入力してください')
    end
  end

  context '通知タイプ：時間間隔の場合、通知時間が数値以外の場合' do
    it '無効であること' do
      task = build(:task, notification_type: 'interval', notification_value: 'aaa')
      expect(task).to be_invalid
      expect(task.errors[:notification_value]).to include('は数値で入力してください')
    end
  end

  context '通知タイプ：固定時間の場合、通知時間が"%H:%M"形式以外の場合' do
    it '無効であること' do
      task = build(:task, notification_type: 'fixed_time', notification_value: 'bbb')
      expect(task).to be_invalid
      expect(task.errors[:notification_value]).to include('はHH:MM形式で入力してください')
    end
  end

  context '通知タイプ：時間間隔の場合、経過時間が通知間隔で割り切れる場合' do
    it 'trueを返すこと' do
      task = create(:task, notification_type: 'interval', notification_value: '30', created_at: 60.minutes.ago)
      expect(task.notification_due?).to be true
    end
  end

  context '通知タイプ：時間間隔の場合、経過時間が通知間隔で割り切れない場合' do
    it 'falseを返すこと' do
      task = create(:task, notification_type: 'interval', notification_value: '30', created_at: 45.minutes.ago)
      expect(task.notification_due?).to be false
    end
  end

  context '通知タイプ：時間間隔の場合、経過時間が0の場合' do
    it 'falseを返すこと' do
      task = create(:task, notification_type: 'interval', notification_value: '30', created_at: Time.current)
      expect(task.notification_due?).to be false
    end
  end

  context '通知タイプ：固定時間の場合、現在時刻が指定時刻と一致する場合' do
    it 'trueを返すこと' do
      task = build(:task, notification_type: 'fixed_time', notification_value: '10:30')
      travel_to Time.zone.local(2026, 1, 1, 10, 30, 0) do
        expect(task.notification_due?).to be true
      end
    end
  end

  context '通知タイプ：固定時間の場合、現在時刻が指定時刻と一致しない場合' do
    it 'falseを返すこと' do
      task = build(:task, notification_type: 'fixed_time', notification_value: '10:30')
      travel_to Time.zone.local(2026, 1, 1, 10, 31, 0) do
        expect(task.notification_due?).to be false
      end
    end
  end

  context 'notification_typeがnilの場合' do
    it 'notification_due?がfalseを返すこと' do
      task = build(:task, notification_type: nil)
      expect(task.notification_due?).to be false
    end
  end

  context 'notification_valueがnilの場合' do
    it 'notification_due?がfalseを返すこと' do
      task = build(:task, notification_value: nil)
      expect(task.notification_due?).to be false
    end
  end
end
