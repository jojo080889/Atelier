class CreateCritiques < ActiveRecord::Migration
  def change
    create_table :critiques do |t|
      t.integer :mentor_id
      t.integer :project_id
      t.string :url

      t.timestamps
    end
  end
end
