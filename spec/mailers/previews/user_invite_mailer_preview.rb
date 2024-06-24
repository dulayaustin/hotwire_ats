# Preview all emails at http://localhost:3000/rails/mailers/user_invite_mailer
class UserInviteMailerPreview < ActionMailer::Preview
  def invite
    if (user = User.where.not(invited_by_id: nil).first).present?
      UserInviteMailer.invite(user)
    end
  end
end
