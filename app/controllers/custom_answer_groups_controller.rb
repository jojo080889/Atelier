class CustomAnswerGroupsController < Rapidfire::AnswerGroupsController
  def create
    # Save the rest of the form
    super
    
    # Save the critique ratings
    errors_exist = false
    @answer_group_builder.answers.each do |a| 
      if a.errors.count > 0
        errors_exist = true
        break
      end
    end

    if !errors_exist
      current_user.critiques_received.each do |c|
        if !params["critique_answer_text_#{c.id}"].nil?
          SurveyCritiqueRatings.create(:user_id => current_user.id, :question_group_id => params[:question_group_id], :critique_id => c.id, :answer_text => params["critique_answer_text_#{c.id}"])
        end
      end
    end
  end
end
