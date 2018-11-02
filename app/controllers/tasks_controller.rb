class TasksController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :require_user_logged_in
  
  def index
    @tasks = current_user.tasks.order("created_at DESC").page(params[:page])
  end
  
  def show
    @task = current_user.tasks.find(params[:id])
  end
  
  def new
    if logged_in?
      @task = current_user.tasks.build
      @tasks = current_user.tasks.order("created_atDESC").page(params[:page])
    end
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = "taskが正常に登録されました"
      redirect_to root_url
      
    else 
      @tasks = current_user.tasks.order("created_at DESC").page(params[:page])
      flash.now[:danger] = "taskが登録されませんでした"
      render "toppages/index"
    end
  end
  
  def edit
    @task = current_user.tasks.find(params[:id])
  end
  
  def update
    @task = current_user.tasks.find(params[:id])
    
    if @task.update(task_params)
      flash[:success] = "Taskは正常に更新されました"
      redirect_to @task
      
    else
      flash.now[:danger] = "Taskは更新されませんでした"
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    
    flash[:success] = "Taskは正常に削除されました"
    redirect_to root_url
  end
  
  private
  
 
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    
    unless @task
      redirect_to tasks_url
    end
  end
end
