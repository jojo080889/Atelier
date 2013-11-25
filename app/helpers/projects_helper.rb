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

  def project_like_button(project, is_liked)
    html = ""
    if is_liked
      html += "<input type='hidden' name='like' class='like' value='1' />"
      html += fa_icon("star")
      html += " <span>I think this project is well-done</span>"
    else
      html += "<input type='hidden' name='like' class='like' value='0' />"
      html += fa_icon("star-o")
      html += " <span>I want to nominate this project as well-done</span>"
    end
    html.html_safe
  end
end
