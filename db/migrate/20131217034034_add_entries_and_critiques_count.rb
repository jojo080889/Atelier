class AddEntriesAndCritiquesCount < ActiveRecord::Migration
  def change
    add_column :projects, :entries_count, :integer, :default => 0
    add_column :entries, :critiques_count, :integer, :default => 0
  end
end
