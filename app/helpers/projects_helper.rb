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

  def project_like_button(project)
    html = ""
    if current_user.voted_up_on? project
      link_to project_unlike_path(project), method: :post, remote: true, class: "project-unlike btn btn-warning" do
        html += fa_icon("star")
        html += " I think this project was well-done"
        html.html_safe
      end
    else
      link_to project_like_path(project), method: :post, remote: true, class: "project-like btn btn-default" do
        html += fa_icon("star") 
        html += " Mark this project as well-done"
        html.html_safe
      end
    end
  end
end
