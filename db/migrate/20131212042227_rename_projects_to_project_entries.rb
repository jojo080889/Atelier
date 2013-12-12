class RenameProjectsToProjectEntries < ActiveRecord::Migration
  def change
    rename_table :projects, :entries
    rename_column :critiques, :project_id, :entry_id
  end
end
