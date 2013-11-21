class Project < ActiveRecord::Base
  belongs_to :user
  has_many :critiques
  attr_accessible :title, :url, :user_id
  before_validation :smart_add_url_protocol

  acts_as_votable

  protected

  def smart_add_url_protocol
    unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
      self.url = "http://#{self.url}"
    end
  end
end
