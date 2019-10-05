class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.random
    offset = rand(self.count)
    self.offset(offset).first
  end
end
