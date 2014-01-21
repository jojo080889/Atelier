class AddSkillLevelToCritique < ActiveRecord::Migration
  def change
    add_column :critiques, :skill_level_id, :integer
  end
end
