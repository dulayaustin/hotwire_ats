class Email < ApplicationRecord
  has_rich_text :body

  enum email_type: {
    outbound: 'outbound',
    inbound: 'inbound'
  }

  belongs_to :applicant
  belongs_to :user

  validates_presence_of :subject

  after_create_commit :send_email, if: :outbound?
  after_create_commit :broadcast_to_applicant
  after_create_commit :notify_recipient, if: :inbound?

  def send_email
    ApplicantMailer.contact(email: self).deliver_now
  end

  def self.build_reply(email_id)
    replying_to = Email.find(email_id)
    original_body = replying_to.body.body.to_html

    email = Email.new(applicant_id: replying_to.applicant_id)
    email.subject = "re: #{replying_to.subject}"
    reply_intro = <<-HTML

      On #{replying_to.created_at.to_date} #{email.applicant.name} wrote:

    HTML
    email.body = original_body.prepend(reply_intro)
    email
  end

  def broadcast_to_applicant
    broadcast_prepend_later_to(
      applicant,
      :emails,
      target: 'emails-list',
      partial: 'emails/list_item',
      locals: {
        email: self,
        applicant: applicant
      }
    )
  end

  def notify_recipient
    NotifyUserJob.perform_later(
      resource_id: id,
      resource_type: 'Email',
      user_id: user.id
    )
  end

  def create_notification(user)
    InboundEmailNotification.create(
      user: user,
      params: {
        applicant: applicant,
        email: self
      }
    )
  end
end
