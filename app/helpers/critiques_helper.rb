module CritiquesHelper
  
  def critique_like_link(critique)
    if current_user.voted_up_on? critique
      link_to project_critique_unlike_path(critique.project, critique), class: "unlike-link", method: :post, remote: true do
        fa_icon "thumbs-up"
        "Liked"
      end
    else
      link_to project_critique_like_path(critique.project, critique), class: "like-link", method: :post, remote: true do
        fa_icon "thumbs-up" 
        "Like this critique"  
      end
    end
  end
end
