module CritiquesHelper
  
  def critique_like_link(critique)
    html = ""
    if current_user.voted_up_on? critique
      link_to entry_critique_unlike_path(critique.entry, critique), class: "unlike-link", method: :post, remote: true do
        html += fa_icon "thumbs-up"
        html += " Marked as helpful"
        html.html_safe
      end
    else
      link_to entry_critique_like_path(critique.entry, critique), class: "like-link", method: :post, remote: true do
        html += fa_icon "thumbs-up" 
        html += " Mark this critique as helpful"  
        html.html_safe
      end
    end
  end
end
