class NotificationMailer < ActionMailer::Base
  default from: "atelier@cs.stanford.edu"

  def critique_received_email(entry)
    @user = entry.user
    @entry = entry
    @folder = entry.folder
    mail(
      to: @user.email,
      subject: "[Atelier] You've received a critique!" 
    )
  end

  def response_received_email(critique)
    @user = critique.user
    @critique = critique
    @entry = critique.entry
    @folder = @entry.folder
    mail(
      to: @user.email,
      subject: "[Atelier] You've received a critique response!"
    )
  end

  def crit_marked_email(critique, entry)
    @user = critique.user
    @critique = critique
    @entry = entry
    @folder = @entry.folder
    mail(
      to: @user.email,
      subject: "[Atelier] Your critique has been marked as helpful!"
    )
  end
end
