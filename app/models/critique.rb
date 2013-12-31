require 'paperclip_string'

class Critique < ActiveRecord::Base
  belongs_to :user
  belongs_to :project, :counter_cache => true
  has_many :responses, :dependent => :destroy
  has_attached_file :paintover
  attr_accessible :user_id, :project_id, :text, :rating, :paintover, :paintover_snapshot, :guest_name

  validates :guest_name, presence: true, if: "user.is_guest?"
  validates :text, presence: true

  after_create :increment_folder_critiques_counter
  after_destroy :decrement_folder_critiques_counter
  after_save :check_for_user_level

  acts_as_votable

  def save_paintover(data)
    data = data.split(',').pop

    self.paintover = Paperclip::base64_to_image("#{self.id}_paintover.png", "image/png", data)
    self.save
  end

  private

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

  # When a critique is created and a user gives and overall rating,
  # check to see if that rating will increase the level of the receiving user.
  def check_for_user_level
    self.project.user.check_for_user_level!
  end
end
