class AddProjectIdToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :project_id, :integer
  end
end
