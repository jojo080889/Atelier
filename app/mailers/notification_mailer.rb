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
    mail(
      to: @user.email,
      subject: "[Atelier] You've received a reply to your critique!"
    )
  end

  def badge_earned_email(badge_sash, user)
      @badge = Merit::Badge.find(badge_sash.badge_id)
      @user = user
      mail(
        to: @user.email,
        subject: "[Atelier] You've made progress to the next skill level!"
      )
  end

  def level_up_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: "[Atelier] You've achieved the next skill level!"
    )
  end
end
