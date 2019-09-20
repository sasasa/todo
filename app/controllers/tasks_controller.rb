class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :task_owner?, only: [:show, :edit, :update, :destroy]
  
  
  # GET /tasks
  def index
    @tasks = current_user.tasks
    # json_hash =
    #   GetWebAPI.new(
    #     "http://api.atnd.org/events/",
    #     {
    #       keyword_or: "ruby",
    #       format: "json"
    #     },
    #     logger).response
    # json_hash["events"] && json_hash["events"].each do |event|
    #   if event["event"] && event["event"]["address"] =~ /東京/
    #     event =
    #       Event.find_or_initialize_by(
    #         url: event["event"]["event_url"]
    #       )
    #     if event.new_record?
    #       event.title = event["event"]["title"],
    #       event.address = event["event"]["address"],
    #       event.started_at = event["event"]["started_at"]
    #       event.save
    #     end
    #   end
    # end
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user = current_user
    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_url, notice: t(".notice", model: Task.model_name.human) }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_url, notice: t(".notice", model: Task.model_name.human) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t(".notice", model: Task.model_name.human) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find_by(id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:content, :finished)
    end

    def task_owner?
      if @task && (@task.user == current_user)
        #logger.debug "task_owner"
      else
        redirect_to root_path, alert: "自身以外のタスクにアクセスできません。"
      end
    end
end
