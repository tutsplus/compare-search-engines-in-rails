class Course < ActiveRecord::Base
  searchable do
    text :title, :category
    float :duration
    time :published_at
  end
end
