class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
  	@tasks = current_user.tasks.order(created_at: :desc)
    # 上記と同義　# @tasks = Task.where(user_id: current_user.id)
    # @tasks = Task.all
  end

  def show
  end

  def new
  	@task = Task.new
  end

  def create
  	@task = Task.new(task_params.merge(user_id: current_user.id))

    if @task.save
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end

  	# 以下のように書くことも可
  	# flash.notice = "タスク「#{task.name}」を登録しました。"

  	# :flashというキーの値にハッシュとして渡せばどのようなキーのデータも渡せる
  	# redirect_to tasks_url, flash: {warning: "何かの警告メッセージ"}

  	# 直後にレンダーするビューに対しては
  	# flash.now[:alert] = "提出期限を過ぎています。"
  	# flash.now.alert = "提出期限を過ぎています。"
  end

  def edit
  end

  def update
  	@task.update!(task_params)
  	redirect_to tasks_url, notice: "タスク「#{task.name}」を更新しました。"
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{task.name}」を削除しました。"
  end

  private

  def task_params
  	params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
