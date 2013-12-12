require 'format'

class Project < ActiveRecord::Base
  belongs_to :user
  has_many :entries
  attr_accessible :name, :description, :user_id
end
