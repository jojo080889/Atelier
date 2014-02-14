module ApplicationHelper
  
  def current_prompt
    if Time.now() < Time.new(2014, 2, 21, 23, 59, 0)
      {:text => "Draw something that starts with the first letter of your name.", 
       :time => Time.new(2014, 2, 21, 23, 59, 0)}
    elsif Time.now() < Time.new(2014, 2, 28, 23, 59, 0)
      {:text => "Illustrate a line from a song.",
       :time => Time.new(2014, 2, 28, 23, 59, 0)}
    elsif Time.now() < Time.new(2014, 3, 7, 23, 59, 0)
      {:text => "Draw somewhere new. Go somewhere new to you and draw what you find.",
       :time => Time.new(2014, 3, 7, 23, 59, 0)}
    elsif Time.now() < Time.new(2014, 3, 14, 23, 59, 0)
      {:text => "Draw something inspired by the word <i>bridge</i>.",
       :time => Time.new(2014, 3, 14, 23, 59, 0)}
    else
      nil
    end
  end
end
