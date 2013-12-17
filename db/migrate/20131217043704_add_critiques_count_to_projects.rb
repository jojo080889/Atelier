class AddCritiquesCountToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :critiques_count, :integer, :default => 0
  end
end
