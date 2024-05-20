class EmailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_applicant
  before_action :set_email, only: %i[ show ]

  def index
    @emails = Email.where(applicant_id: @applicant.id).with_rich_text_body.order(created_at: :asc)
  end

  def show
    html = render_to_string(partial: 'emails/email', locals: { email: @email } )
    render cable_ready: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slideover-header', text: @email.subject)
  end

  def new
    @email = Email.new
    html = render_to_string(partial: 'emails/form', locals: { applicant: @applicant, email: @email } )
    render cable_ready: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slideover-header', text: "Email #{@applicant.name}")
  end

  def create
    @email = Email.new(email_params)
    @email.applicant = @applicant
    @email.user = current_user
    @email.email_type = 'outbound'

    if @email.save
      html = render_to_string(partial: 'shared/flash', locals: { level: :success, content: 'Email sent!' } )
      render cable_ready: cable_car
        .inner_html('#flash-container', html: html)
        .dispatch_event(name: 'submit:success')
    else
      html = render_to_string(partial: 'emails/form', locals: { applicant: @applicant, email: @email } )
      render cable_ready: cable_car
        .inner_html('#email-form', html: html), status: :unprocessable_entity
    end
  end

  private

    def set_email
      @email = Email.find(params[:id])
    end

    def set_applicant
      @applicant = Applicant.find(params[:applicant_id])
    end

    def email_params
      params.require(:email).permit(:subject, :body)
    end
end
