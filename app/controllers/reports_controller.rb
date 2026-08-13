# app/controllers/reports_controller.rb
class ReportsController < ApplicationController
  before_action :set_task

  def new
    @report = @task.reports.new(status: :in_progress)
    @back_path = safe_back_path(request.referer) || task_path(@task)
  end

  def create
    @report = @task.reports.build(report_params)
    if @report.save
      redirect_to task_path(@task), notice: "報告が完了しました"
    else
      flash.now[:danger] = "報告が失敗しました"
      @back_path = safe_back_path(params[:back_path]) || task_path(@task)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @report = @task.reports.find(params[:id])
  end

  def update
    @report = @task.reports.find(params[:id])
    if @report.update(report_params)
      redirect_to task_path(@task), notice: "報告内容を更新しました"
    else
      flash.now[:danger] = "報告内容の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def set_task
    @task = current_user.tasks.find(params[:task_id])
  end

  def report_params
    params.require(:report).permit(:status, :memo)
  end

  def safe_back_path(url)
    return nil if url.blank?

    begin
      uri = URI.parse(url)
    rescue URI::InvalidURIError
      return nil
    end

    # 相対パス、または自サイト内のURLのみ許可
    return nil unless uri.host.nil? || uri.host == request.host

    uri.path.presence
  end
end
