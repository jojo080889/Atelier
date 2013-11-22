class RenameMentorIdToUserIDinCritiques < ActiveRecord::Migration
  def up
    rename_column :critiques, :mentor_id, :user_id
  end

  def down
    rename_column :critiques, :user_id, :mentor_id
  end
end
