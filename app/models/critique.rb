require 'paperclip_string'

class Critique < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry, :counter_cache => true
  has_many :responses, :dependent => :destroy
  has_attached_file :paintover
  attr_accessible :user_id, :entry_id, :text, :rating, :paintover, :paintover_snapshot

  after_create :increment_project_critiques_counter
  after_destroy :decrement_project_critiques_counter

  acts_as_votable

  def save_paintover(data)
    data = data.split(',').pop

    self.paintover = Paperclip::base64_to_image("#{self.id}_paintover.png", "image/png", data)
    self.save
  end

  private

  def increment_project_critiques_counter
    Project.increment_counter(:critiques_count, self.entry.project.id) 
  end

  def decrement_project_critiques_counter
    Project.decrement_counter(:critiques_count, self.entry.project.id)
  end
end
