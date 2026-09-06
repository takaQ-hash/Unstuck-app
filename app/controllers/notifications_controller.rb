class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :send_push ]
  skip_before_action :authenticate_user!, only: [ :send_push ]

  def send_push
    return head :unauthorized unless params[:token] == Rails.application.credentials.push_notification_token

    Task.find_each do |task|
      task.send_push_notification if task.notification_due?
    end

    head :ok
  end
end
