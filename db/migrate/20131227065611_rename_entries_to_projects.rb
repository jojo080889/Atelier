class RenameEntriesToProjects < ActiveRecord::Migration
  def change
    rename_table :entries, :projects
    rename_column :critiques, :entry_id, :project_id
  end
end
