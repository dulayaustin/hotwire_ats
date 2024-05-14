class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: %i[ edit update destroy ]

  def index
    @jobs = Job.all
  end

  def new
    html = render_to_string(partial: 'jobs/form', locals: { job: Job.new } )
    render cable_ready: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slideover-header', text: 'Post a new job')
  end

  def edit
    html = render_to_string(partial: 'jobs/form', locals: { job: @job } )
    render cable_ready: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slideover-header', text: 'Edit job')
  end

  def create
    @job = Job.new(job_params)
    @job.account = current_user.account

    if @job.save
      html = render_to_string(partial: 'jobs/job', locals: { job: @job } )
      render cable_ready: cable_car
        .prepend('#jobs', html: html)
        .dispatch_event(name: 'submit:success')
    else
      html = render_to_string(partial: 'jobs/form', locals: { job: @job } )
      render cable_ready: cable_car
        .inner_html('#job-form', html: html), status: :unprocessable_entity
    end
  end

  def update
    if @job.update(job_params)
      html = render_to_string(partial: 'jobs/job', locals: { job: @job } )
      render cable_ready: cable_car
        .replace(dom_id(@job), html: html)
        .dispatch_event(name: 'submit:success')
    else
      html = render_to_string(partial: 'jobs/form', locals: { job: @job } )
      render cable_ready: cable_car
        .inner_html('#job-form', html: html), status: :unprocessable_entity
    end
  end

  def destroy
    @job.destroy!
    render cable_ready: cable_car.remove(selector: dom_id(@job))
  end

  private
    def set_job
      @job = Job.find(params[:id])
    end

    def job_params
      params.require(:job).permit(:title, :status, :job_type, :location, :description)
    end
end
