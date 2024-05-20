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

  def send_email
    ApplicantMailer.contact(email: self).deliver_later
  end
end
