class RemoveUrlFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :url
  end
end
