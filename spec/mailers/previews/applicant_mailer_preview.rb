# Preview all emails at http://localhost:3000/rails/mailers/applicant_mailer
class ApplicantMailerPreview < ActionMailer::Preview
  def contact
    # email = FactoryBot.build(:email)
    if (email = Email.first).present?
      ApplicantMailer.contact(email: email)
    end
  end
end
