class TasksController < ApplicationController
  def index
    @tasks = current_user.tasks.includes(:user).order(created_at: :desc)
  end

  def new
    @task = Task.new(notification_type: :interval)
    @back_path = safe_back_path(request.referer) || tasks_path
  end

  def show
    @task = current_user.tasks.find(params[:id])
    @reports = @task.reports.order(created_at: :desc)
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: "タスクを登録しました"
    else
      flash.now[:danger] = "タスクの登録に失敗しました"
      @back_path = safe_back_path(params[:back_path]) || tasks_path
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task = current_user.tasks.find(params[:id])
    @back_path = safe_back_path(request.referer) || tasks_path
  end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを更新しました"
    else
      flash.now[:danger] = "タスクの更新に失敗しました"
      @back_path = safe_back_path(params[:back_path]) || tasks_path
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    task =  current_user.tasks.find(params[:id])
    task.destroy!
    redirect_to tasks_path,  notice: "タスクを削除しました"
  end

  private

  def task_params
     params.require(:task).permit(:name, :deadline, :notification_type, :notification_value)
  end

  def safe_back_path(url)
    return nil if url.blank?

    begin
      uri = URI.parse(url)
    rescue URI::InvalidURIError
      return nil
    end

    return nil unless uri.host.nil? || uri.host == request.host

    uri.path.presence
  end
end
