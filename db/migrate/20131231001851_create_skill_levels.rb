class CreateSkillLevels < ActiveRecord::Migration
  def change
    create_table :skill_levels do |t|
      t.string :name_key, null: false
      t.timestamps
    end

    add_column :users, :skill_level_id, :integer, default: 1, null: false
  end
end
