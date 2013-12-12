class AddDefaultValueToEntryContent < ActiveRecord::Migration
  def change
    change_column :entries, :content, :text, :default => ""
  end
end
