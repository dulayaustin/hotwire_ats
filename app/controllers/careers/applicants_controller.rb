class Careers::ApplicantsController < CareersController
  before_action :set_job

  def new
    html = render_to_string(partial: 'careers/applicants/form', locals: { applicant: Applicant.new } )
    render cable_ready: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slideover-header', text: "Apply for #{@job.title}")
  end

  def create
    @applicant = Applicant.new(applicant_params)
    @applicant.job = @job
    @applicant.stage = 'application'

    if @applicant.save
      html = render_to_string(partial: 'careers/applicants/success', locals: { applicant: @applicant, job: @job } )
      render cable_ready: cable_car
        .inner_html('#slideover-content', html: html)
        .set_attribute('#apply-button', name: 'disabled', value: '')
    else
      html = render_to_string(partial: 'careers/applicants/form', locals: { applicant: @applicant } )
      render cable_ready: cable_car
        .inner_html('#applicant-form', html: html), status: :unprocessable_entity
    end
  end

  private

    def set_job
      @job = Job.find(params[:job_id])
    end

    def applicant_params
      params.require(:applicant).permit(:first_name, :last_name, :email, :phone, :resume)
    end
end
