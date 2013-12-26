class ChangePaintoverSnapshotType < ActiveRecord::Migration
  def up
    change_column :critiques, :paintover_snapshot, :text
  end

  def down
    change_column :critiques, :paintover_snapshot, :string
  end
end
