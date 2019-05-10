class ApplicationRecord < ActiveRecord::Base
  include Paginator
  self.abstract_class = true
end
