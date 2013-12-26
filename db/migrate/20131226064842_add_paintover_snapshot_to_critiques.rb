class AddPaintoverSnapshotToCritiques < ActiveRecord::Migration
  def change
    add_column :critiques, :paintover_snapshot, :string
  end
end
