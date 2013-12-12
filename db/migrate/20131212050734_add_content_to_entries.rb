class AddContentToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :content, :text
  end
end
