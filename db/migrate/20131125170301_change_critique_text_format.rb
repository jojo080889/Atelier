class ChangeCritiqueTextFormat < ActiveRecord::Migration
  def up
    change_column :critiques, :text, :text
  end

  def down
    change_column :critiques, :text, :string
  end
end
