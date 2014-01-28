class BadgesSashObserver < ActiveRecord::Observer
  observe Merit::BadgesSash

  def after_create(badge_sash)
    if Atelier::Application.config.skill_levels
      user = User.find_by_sash_id(badge_sash.sash_id)

      # Notify the user
      NotificationMailer.badge_earned_email(badge_sash, user).deliver

      # Check if they're eligible for advancing to the next
      # skill level
      @available_badges = Merit::Badge.find { |b| b.custom_fields[:skill_level] == user.skill_level.name_key.to_sym }
      @available = @available_badges.keys
      @earned = user.badges.map {|b| b.id}.uniq
      if (@available - @earned).empty?
        user.skill_level_id = user.skill_level.higher_tier.id
        user.save

        # Check if user has earned any badges for their
        # new level
        user.check_for_badges!

        # Notify about levelling up!
        NotificationMailer.level_up_email(user).deliver
      end
    end
  end
end
