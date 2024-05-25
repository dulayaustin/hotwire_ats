class UserInviteMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_invite_mailer.invite.subject
  #
  def invite(user)
    # @greeting = "Hi"

    # mail to: "to@example.org"
    @user = user
    @inviting_user = user.invited_by

    mail(
      to: @user.email,
      subject: "#{@inviting_user.name} wants you to join Hotwired ATS"
    )
  end
end
