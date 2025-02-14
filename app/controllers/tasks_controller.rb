class TasksController < ApplicationController
  before_action :authenticate_user
  before_action :set_task, only: [:show, :update, :destroy]
  include PaginationConcern

  def index
    tasks = @current_user.tasks
    tasks = Kaminari.paginate_array(tasks).page(params[:page]).per(params[:per_page])
    render json: TaskSerializer.new(tasks).serializable_hash, status: :ok
  end

  def create
    task = @current_user.tasks.new(task_params)
    if task.save
      render json: TaskSerializer.new(tasks).serializable_hash, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: TaskSerializer.new(@task).serializable_hash, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def show
    render json: TaskSerializer.new(@task).serializable_hash, status: :ok
  end


  def destroy
    @task.destroy
    render json: {message: "Task deleted successfull."}, status: 200
  end

  private

  def task_params
    params.permit(:title, :description, :status, :due_date)
  end

  def set_task
  	return render json: {error: "Task not found with given id"}, status: :unprocessable_entity unless params[:id].present?
    @task = current_user.tasks.find(params[:id])
  end

  def authenticate_user
    header = request.headers['Authorization'].split(' ').last

    begin
      @decoded = JWT.decode(header, Rails.application.secret_key_base, true, { algorithm: 'HS256' })
      @current_user = User.find(@decoded[0]['user_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
