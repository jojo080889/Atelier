module ProjectsHelper
  def skill_level_badge(skill_level)
    if Atelier::Application.config.skill_levels
      case skill_level.name_key.to_sym
      when :beginner
        badge_type = "label-warning"
      when :intermediate
        badge_type = "label-info"
      when :advanced
        badge_type = "label-success"
      else
        badget_type = "table-default"
      end
      "<span class='label #{badge_type}'>#{skill_level.name_key.titleize}</span>".html_safe
    end
  end
end
