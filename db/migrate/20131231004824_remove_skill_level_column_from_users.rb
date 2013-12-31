class RemoveSkillLevelColumnFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :skill_level
  end
end
