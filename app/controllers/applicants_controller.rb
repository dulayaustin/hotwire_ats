class ApplicantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_applicant, only: %i[ edit update destroy change_stage ]

  def index
    @applicants = Applicant.all
  end

  def new
    html = render_to_string(partial: 'applicants/form', locals: { applicant: Applicant.new } )
    render cable_ready: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slidover-header', text: 'Add an applicant')
  end

  def create
    @applicant = Applicant.new(applicant_params)

    if @applicant.save
      html = render_to_string(partial: 'applicants/card', locals: { applicant: @applicant } )
      render cable_ready: cable_car
        .prepend("#applicants-#{@applicant.stage}", html: html)
        .dispatch_event(name: 'submit:success')
    else
      html = render_to_string(partial: 'applicants/form', locals: { applicant: @applicant } )
      render cable_ready: cable_car
        .inner_html('#applicant-form', html: html), status: :unprocessable_entity
    end
  end

  def edit
    html = render_to_string(partial: 'applicants/form', locals: { applicant: @applicant } )
    render cable_ready: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slidover-header', text: 'Update an applicant')
  end

  def update
    if @applicant.update(applicant_params)
      html = render_to_string(partial: 'applicants/card', locals: { applicant: @applicant } )
      render cable_ready: cable_car
        .replace(dom_id(@applicant), html: html)
        .dispatch_event(name: 'submit:success')
    else
      html = render_to_string(partial: 'applicants/form', locals: { applicant: @applicant } )
      render cable_ready: cable_car
        .inner_html('#applicant-form', html: html), status: :unprocessable_entity
    end
  end

  def destroy
    @applicant.destroy!
    render cable_ready: cable_car.remove(selector: dom_id(@applicant))
  end

  def change_stage
    @applicant.update(applicant_params)
    head :ok
  end

  private
    def set_applicant
      @applicant = Applicant.find(params[:id])
    end

    def applicant_params
      params.require(:applicant).permit(:first_name, :last_name, :email, :phone, :stage, :status, :job_id, :resume)
    end
end
