class NotificationMailer < ActionMailer::Base
  default from: "atelier@cs.stanford.edu"

  def critique_received_email(project)
    @user = project.user
    @project = project
    @folder = project.folder
    mail(
      to: @user.email,
      subject: "[Atelier] You've received a critique!" 
    )
  end

  def critique_rated_email(critique)
    @user = critique.user
    @critique = critique
    @project = critique.project
    mail(
      to: @user.email,
      subject: "[Atelier] You've received a critique rating!"
    )
  end

  def response_received_email(critique)
    @user = critique.user
    @critique = critique
    @project = critique.project
    @folder = @project.folder
    mail(
      to: @user.email,
      subject: "[Atelier] You've received a reply to your critique!"
    )
  end
end
