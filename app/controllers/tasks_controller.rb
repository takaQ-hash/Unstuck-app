class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:user).order(created_at: :desc)
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

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを更新しました"
    else
      flash.now[:danger] = "タスクの更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  
  end
  
  private

  def task_params
     params.require(:task).permit(:name, :deadline, :notification_type, :notification_value)
  end
end
