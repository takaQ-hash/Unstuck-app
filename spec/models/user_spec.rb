require 'rails_helper'

RSpec.describe User, type: :model do
  context '名前、メールアドレス、パスワードが全項目が正しく入力されている場合' do
    it '有効であること' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  context '名前が存在しない場合' do
    it '無効であること' do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to include('を入力してください')
    end
  end

  context 'メールアドレスが存在しない場合' do
    it '無効であること' do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to include('を入力してください')
    end
  end

  context 'パスワードが存在しない場合' do
    it '無効であること' do
      user = build(:user, password: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to include('を入力してください')
    end
  end

  context 'パスワードが6文字未満の場合' do
    it '無効であること' do
      user = build(:user, password: 'a' * 5)
      expect(user).to be_invalid
    end
  end

  context 'メールアドレスに"@"がない場合' do
    it '無効であること' do
      user = build(:user, email: 'aaa.com')
      expect(user).to be_invalid
    end
  end

  context 'メールアドレスがユニークでない場合' do
    it '無効であること' do
      user1 = create(:user)
      user2 = build(:user)
      user2.email = user1.email
      user2.valid?
      expect(user2.errors[:email]).to include('はすでに存在します')
    end
  end

  context 'ユーザーが削除された場合' do
    it '削除されたユーザーに紐づくタスクが削除されること' do
      user = create(:user)
      create(:task, user: user)
      expect { user.destroy! }.to change(Task, :count).by(-1)
    end
  end
end
