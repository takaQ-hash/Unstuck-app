class ReportsController < ApplicationController
  before_action :set_task

  def new
    @report = @task.reports.new(status: :in_progress)
    @back_path = request.referer || task_path(@task)
  end

  def create
    @report = @task.reports.build(report_params)
    if @report.save
      redirect_to task_path(@task), notice: "報告が完了しました"
    else
      flash.now[:danger] = "報告が失敗しました"
      @back_path = params[:back_path] || task_path(@task)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:task_id])
  end

  def report_params
    params.require(:report).permit(:status, :memo)
  end
end
