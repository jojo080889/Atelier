module CritiquesHelper
  def critique_rating_buttons(recipient, rater, remote = false, project = nil, critique = nil)
    html = "<div class='rating-container btn-group'>"
    
    if recipient.has_skill_level?(:beginner)
      html += "<a class='rating beginner btn btn-default"
      html += " btn-warning" if recipient.has_skill_level?(:beginner) && !remote
      if remote
        html += "' "
        html += "data-method='post' "
        html += "data-remote='true' "
        html += "href='#{project_critique_rating_path(project, critique, SkillLevel.find_by_name_key(:beginner))}"
      end
      html += "'>"
      if !remote
        html += fa_icon "star"
      else
        html += fa_icon "o-star"
      end
      html += " Beginner"
      html += "</a>"
    end

    if rater.has_skill_level?(:intermediate) || rater.has_skill_level?(:advanced)
      html += "<a class='rating intermediate btn btn-default"
      html += " btn-warning" if recipient.has_skill_level?(:intermediate) && !remote
      if remote
        html += "' "
        html += "data-method='post' "
        html += "data-remote='true' "
        html += "href='#{project_critique_rating_path(project, critique, SkillLevel.find_by_name_key(:intermediate))}"
      end
      html += "'>"
      if !remote && recipient.has_skill_level?(:intermediate)
        html += fa_icon "star"
      else
        html += fa_icon "star-o"
      end
      html += " Intermediate"
      html += "</a>"
    end

    if rater.has_skill_level?(:advanced)
      html += "<a class='rating advanced btn btn-default"
      if remote
        html += "' "
        html += "data-method='post' "
        html += "data-remote='true' "
        html += "href='#{project_critique_rating_path(project, critique, SkillLevel.find_by_name_key(:advanced))}"
      end
      html += "'>"
      html += fa_icon "star-o"
      html += " Advanced"
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
