# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Skill Levels
[:beginner, :intermediate, :advanced].each do |skill_level|
  SkillLevel.find_or_create_by_name_key skill_level
end
