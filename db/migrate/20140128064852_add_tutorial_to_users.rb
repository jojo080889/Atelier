class AddTutorialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tutorial_done, :boolean, :default => false
  end
end
