class NotificationMailer < ActionMailer::Base
  default from: "atelier@cs.stanford.edu"

  def critique_received_email(project)
    @user = project.user
    @project = project
    mail(
      to: @user.email,
      subject: "[Atelier] You've received a critique!" 
    )
  end
end
