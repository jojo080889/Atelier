class AddPaintoverToCritiques < ActiveRecord::Migration
  def self.up
    add_attachment :critiques, :paintover
  end

  def self.down
    remove_attachment :critiques, :paintover
  end
end
