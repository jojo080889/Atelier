class AddImageToEntries < ActiveRecord::Migration
  def self.up
    add_attachment :entries, :image
  end

  def self.down
    remove_attachment :entries, :image
  end
end
