require 'elasticsearch/model'

class Course < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
end

Course.__elasticsearch__.create_index!
