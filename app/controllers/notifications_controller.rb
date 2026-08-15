class NotificationsController < ApplicationController
  def due_tasks
    tasks = current_user.tasks.select(&:notification_due?)
    render json: tasks.as_json(only: [ :id, :name ])
  end
end
