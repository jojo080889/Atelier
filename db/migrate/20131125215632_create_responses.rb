class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :user_id
      t.integer :critique_id
      t.text :text

      t.timestamps
    end
  end
end
