class NotificationMailer < ActionMailer::Base
  default from: "atelier@cs.stanford.edu"

  def critique_received_email(entry)
    @user = entry.user
    @entry = entry
    @project = entry.project
    mail(
      to: @user.email,
      subject: "[Atelier] You've received a critique!" 
    )
  end

  def response_received_email(critique)
    @user = critique.user
    @critique = critique
    @entry = critique.entry
    @project = @entry.project
    mail(
      to: @user.email,
      subject: "[Atelier] You've received a critique response!"
    )
  end
end
