#require 'elasticsearch/model'

class Course < ActiveRecord::Base
  #include Elasticsearch::Model
  #include Elasticsearch::Model::Callbacks
  searchable do
    text :title, :category
    float :duration
    time :published_at
  end
end

#Course.__elasticsearch__.create_index!
