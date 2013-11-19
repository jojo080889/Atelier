class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.integer :user_id
      t.string :url

      t.timestamps
    end
  end
end
