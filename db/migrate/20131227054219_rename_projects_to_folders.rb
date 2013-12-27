class RenameProjectsToFolders < ActiveRecord::Migration
  def change
    rename_table :projects, :folders
  end
end
