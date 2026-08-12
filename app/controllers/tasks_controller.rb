class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:user)
  end

  def new
    @task = Task.new(notification_type: :interval)
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: "タスクを登録しました"
    else
      flash.now[:danger] = "タスクの登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def task_params
     params.require(:task).permit(:name, :deadline, :notification_type, :notification_value)
  end
end
