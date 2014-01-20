class AddStartedAtToCritiques < ActiveRecord::Migration
  def change
    add_column :critiques, :started_at, :datetime
  end
end
