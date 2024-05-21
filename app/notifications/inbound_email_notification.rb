class InboundEmailNotification < Notification
  def message
    "#{params.dig("email", "subject")} from #{params.dig("applicant", "first_name")} #{params.dig("applicant", "last_name")}"
  end

  def url
    applicant_email_path(params.dig("applicant", "id"), params.dig("email", "id"))
  end
end