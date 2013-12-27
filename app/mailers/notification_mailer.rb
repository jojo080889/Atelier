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

  def response_received_email(critique)
    @user = critique.user
    @critique = critique
    @project = critique.project
    @folder = @project.folder
    mail(
      to: @user.email,
      subject: "[Atelier] You've received a critique response!"
    )
  end

  def crit_marked_email(critique, project)
    @user = critique.user
    @critique = critique
    @project = project
    @folder = @project.folder
    mail(
      to: @user.email,
      subject: "[Atelier] Your critique has been marked as helpful!"
    )
  end
end
