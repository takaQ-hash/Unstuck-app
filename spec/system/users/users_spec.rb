require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン' do
    context '認証情報が正しい場合' do
      it 'ログインできること' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'MyString'
        click_button 'ログイン'
        expect(page).to have_current_path(root_path)
        expect(page).to have_content('ログインしました。')
      end
    end

    context 'パスワードに誤りがある場合' do
      it 'ログインできないこと' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'wrongpassword'
        click_button 'ログイン'
        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content('メールアドレスまたはパスワードが違います。')
      end
    end
  end

  describe 'ログアウト' do
    before do
      sign_in user
    end

    it 'ログアウトできること' do
      visit root_path
      click_button 'ログアウト'
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content('ログインもしくはアカウント登録してください。')
    end
  end

  describe '新規登録' do
    context '入力項目が正しく、チェックボックスにチェックがある場合' do
      it 'ユーザーが新規作成できること' do
        visit new_user_registration_path
        expect {
          fill_in 'お名前', with: 'テスト太郎'
          fill_in 'メールアドレス', with: 'exampleeee@example.com'
          fill_in 'パスワード', with: 'MyString'
          fill_in 'パスワード（確認用）', with: 'MyString'
          check '利用規約・プライバシーポリシーに同意する'
          click_button '登録する'
          expect(page).to have_current_path(root_path)
        }.to change(User, :count).by(1)
        expect(page).to have_content('アカウント登録が完了しました。')
      end
    end

    context '入力項目が正しく、チェックボックスにチェックがない場合' do
      it '登録ボタンが非活性であること' do
        visit new_user_registration_path
        fill_in 'お名前', with: 'テスト太郎'
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in 'パスワード', with: 'MyString'
        fill_in 'パスワード（確認用）', with: 'MyString'
        expect(page).to have_button('登録する', disabled: true)
      end
    end

    context '入力情報に不備がある場合' do
      it 'ユーザーが新規作成できないこと' do
        visit new_user_registration_path
        expect {
          fill_in 'メールアドレス', with: 'example@example.com'
          check '利用規約・プライバシーポリシーに同意する'
          click_button '登録する'
        }.not_to change(User, :count)
        expect(page).to have_content('名前を入力してください')
        expect(page).to have_content('パスワードを入力してください')
      end
    end

    context 'すでに登録されているメールアドレスの場合' do
      it 'ユーザーが新規作成できないこと' do
        existing_user = create(:user)
        visit new_user_registration_path
        expect {
          fill_in 'お名前', with: 'テスト太郎'
          fill_in 'メールアドレス', with: existing_user.email
          fill_in 'パスワード', with: 'MyString'
          fill_in 'パスワード（確認用）', with: 'MyString'
          check '利用規約・プライバシーポリシーに同意する'
          click_button '登録する'
        }.not_to change(User, :count)
        expect(page).to have_content('メールアドレスはすでに存在します')
      end
    end
  end
end
