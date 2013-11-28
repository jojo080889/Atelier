module ProjectsHelper
  def skill_level_badge(skill_level)
    case skill_level
    when "Beginner"
      badge_type = "label-warning"
    when "Intermediate"
      badge_type = "label-info"
    when "Advanced"
      badge_type = "label-success"
    else
      badget_type = "table-default"
    end
    "<span class='label #{badge_type}'>#{skill_level}</span>".html_safe
  end

  def skill_level_to_rating(skill_level)
    case skill_level
    when "Beginner"
      1
    when "Intermediate"
      3
    when "Advanced"
      5
    end
  end

  def rating_to_skill_level(rating)
    case rating
    when 1
      "Beginner"
    when 3
      "Intermediate"
    when 5
      "Advanced"
    end
  end
end
