module CritiquesHelper
  def critique_rating_buttons(start_level, end_level, selected_level = nil, remote = false, project = nil, critique = nil)
    html = "<div class='rating-container btn-group'>"
    
    if start_level == :beginner
      html += "<a class='rating beginner btn btn-default"
      html += " btn-warning" if selected_level == :beginner
      if remote
        html += "' "
        html += "data-method='post' "
        html += "data-remote='true' "
        html += "href='#{project_critique_rating_path(project, critique, SkillLevel.find_by_name_key(:beginner))}"
      end
      html += "'>"
      if selected_level == :beginner
        html += fa_icon "star"
      else
        html += fa_icon "star-o"
      end
      if remote && start_level == :beginner
        html += " Same<br /><small>(Beginner)</small>"
      else
        html += " Beginner"
      end
      html += "</a>"
    end

    if start_level == :intermediate || end_level == :intermediate || end_level == :advanced
      html += "<a class='rating intermediate btn btn-default"
      html += " btn-warning" if selected_level == :intermediate
      if remote
        html += "' "
        html += "data-method='post' "
        html += "data-remote='true' "
        html += "href='#{project_critique_rating_path(project, critique, SkillLevel.find_by_name_key(:intermediate))}"
      end
      html += "'>"
      if selected_level == :intermediate
        html += fa_icon "star"
      else
        html += fa_icon "star-o"
      end
      if remote && start_level == :intermediate
        html += " Same<br /><small>(Intermediate)</small>"
      elsif remote && end_level == :intermediate
        html += " Better<br /><small>(Intermediate)</small>"
      else
        html += " Intermediate"
      end
      html += "</a>"
    end

    if end_level == :advanced
      html += "<a class='rating advanced btn btn-default"
      if remote
        html += "' "
        html += "data-method='post' "
        html += "data-remote='true' "
        html += "href='#{project_critique_rating_path(project, critique, SkillLevel.find_by_name_key(:advanced))}"
      end
      html += "'>"
      html += fa_icon "star-o"
      if remote && end_level == :advanced
        html += "Better<br /><small>(Advanced)</small>"
      else
        html += " Advanced"
      end
      html += "</a>"
    end

    html += "</div>"
    html.html_safe
  end
 
  def critique_hints(user)
    if user.has_skill_level?(:beginner)
      html = "<ul>"
      html += "<li>"
      html += "Be respectful, encouraging, and specific with your comments."
      html += "</li>"
      html += "<li>"
      html += "Pointing to resources that have helped you in the past is a good way to give advice."
      html += "</li>"
      html += "</ul>"
    else
      html = "<ul>"
      html += "<li>"
      html += "Be respectful, encouraging, and specific with your comments."
      html += "</li>"
      html += "<li>"
      html += "Comment on your mentee\'s technical skill. What are some great ways they used the tools and materials at their disposal? What are some ways they could improve?"
      html += "</li>"
      html += "<li>"
      html += "As a viewer, what is your reaction to the piece? What do you notice about the piece's content, and how do you feel about it?"
      html += "</li>"
      html += "<li>"
      html += "If their work was particularly well-done for their skill level, say so through your overall rating of the project."
      html += "</li>"
      html += "</ul>"
    end
    html.html_safe
  end
end
