require 'paperclip_string'

class Critique < ActiveRecord::Base
  belongs_to :user
  belongs_to :project, :counter_cache => true
  has_many :responses, :dependent => :destroy
  has_many :critique_ratings, :dependent => :destroy
  has_attached_file :paintover
  attr_accessible :user_id, :project_id, :text, :rating, :started_at, :skill_level_id, :paintover, :paintover_snapshot, :guest_name

  validates :guest_name, presence: true, length: { maximum: 50 }, if: "user_is_guest?"
  validates :text, presence: true

  after_create :increment_folder_critiques_counter
  after_destroy :decrement_folder_critiques_counter

  acts_as_votable
  is_impressionable

  def save_paintover(data)
    data = data.split(',').pop

    self.paintover = Paperclip::base64_to_image("#{self.id}_paintover.png", "image/png", data)
    self.save
  end

  def project_user
    self.project.user
  end

  private

  def user_is_guest?
    self.user.nil?
  end

  def increment_folder_critiques_counter
    if !self.project.folder.nil?
      Folder.increment_counter(:critiques_count, self.project.folder.id) 
    end
  end

  def decrement_folder_critiques_counter
    if !self.project.folder.nil?
      Folder.decrement_counter(:critiques_count, self.project.folder.id)
    end
  end
end
