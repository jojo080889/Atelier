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
end
