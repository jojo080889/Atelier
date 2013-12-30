module CritiquesHelper
  
  def critique_like_link(critique)
    html = ""
    if current_user.voted_up_on? critique
      link_to project_critique_unlike_path(critique.project, critique), class: "unlike-link", method: :post, remote: true do
        html += fa_icon "thumbs-up"
        html += " Marked as helpful"
        html.html_safe
      end
    else
      link_to project_critique_like_path(critique.project, critique), class: "like-link", method: :post, remote: true do
        html += fa_icon "thumbs-up" 
        html += " Mark this critique as helpful"  
        html.html_safe
      end
    end
  end

  def critique_hints(user)
    if user.skill_level == "Beginner"
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
