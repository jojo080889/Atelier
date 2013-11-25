class ChangeCritiqueUrlToText < ActiveRecord::Migration
  def up
    rename_column :critiques, :url, :text
  end

  def down
    rename_column :critiques, :text, :url
  end
end
