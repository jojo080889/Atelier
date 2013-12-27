class ChangeProjectsIdInEntries < ActiveRecord::Migration
  def change
    rename_column :entries, :project_id, :folder_id
  end
end
