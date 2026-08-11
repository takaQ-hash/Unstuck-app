require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /index" do
    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトされる" do
        get "/"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
