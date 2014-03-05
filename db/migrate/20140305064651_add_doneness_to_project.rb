class AddDonenessToProject < ActiveRecord::Migration
  def change
    add_column :projects, :doneness, :string
  end
end
