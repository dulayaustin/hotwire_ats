class ApplicantCommentNotification < Notification
  def message
    "#{params.dig("user", "first_name")} #{params.dig("user", "last_name")} mentioned you in a comment on #{params.dig("applicant", "first_name")} #{params.dig("applicant", "last_name")}"
  end

  def url
    applicant_comments_path(params.dig("applicant", "id"))
  end
end