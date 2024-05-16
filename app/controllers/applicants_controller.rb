class ApplicantsController < ApplicationController
  include Filterable

  before_action :authenticate_user!
  before_action :set_applicant, only: %i[ edit update destroy change_stage ]

  def index
    # @applicants = Applicant.all

    # if search_params.present?
    #   @applicants = Applicant.includes(:job)
    #   @applicants = @applicants.where(job_id: search_params[:job]) if search_params[:job].present?
    #   # @applicants = @applicants.where("first_name ILIKE ? OR last_name ILIKE ?", "%#{search_params[:query]}%", "%#{search_params[:query]}%") if search_params[:query].present?
    #   @applicants = @applicants.text_search(search_params[:query]) if search_params[:query].present?
    #   if search_params[:sort].present?
    #     sort = search_params[:sort].split('-')
    #     @applicants = @applicants.order("#{sort[0]} #{sort[1]}")
    #   end
    # else
    #   @applicants = Applicant.includes(:job).all
    # end

    @applicants = filter!(Applicant).for_account(current_user.account_id)
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

    # def search_params
    #   params.permit(:query, :job, :sort)
    # end
end
