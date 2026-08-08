class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:user)
  end
end
