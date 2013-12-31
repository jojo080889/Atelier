require_dependency "enum"

class SkillLevel < ActiveRecord::Base
  attr_reader :name
  attr_accessible :id
  
  # Used to compare levels against each other.
  # Make sure this matches the levels in the database.
  def self.levels
    @levels ||= Enum.new(
      :beginner, :intermediate, :advanced, start: 0
    )
  end

  # Checks if a given symbol matches a level in the database.
  def self.valid_level?(level)
    !SkillLevel.find_by_name_key(level).nil?
  end

  # Compares two skill levels to see if they include one.
  def self.compare(current_level, level)
    SkillLevel.levels[current_level.name_key.to_sym] >= SkillLevel.levels[level.name_key.to_sym]
  end

  def self.compare_exact(level, other_level)
    SkillLevel.levels[level.name_key.to_sym] == SkillLevel.levels[other_level.name_key.to_sym]
  end

  def to_s
    self.name_key.titleize
  end

  def lower_tier
    skill_index = [0, SkillLevel.levels[self.name_key.to_sym] - 1].max
    SkillLevel.find_by_name_key(SkillLevel.levels[skill_index])
  end

  def higher_tier
    skill_index = [SkillLevel.levels[self.name_key.to_sym] + 1, SkillLevel.levels.size - 1].min
    SkillLevel.find_by_name_key(SkillLevel.levels[skill_index])
  end

  def lowest?
    SkillLevel.levels[self.name_key.to_sym] == 0
  end

  def highest?
    SkillLevel.levels[self.name_key.to_sym] == (SkillLevel.levels.size - 1)
  end
end
