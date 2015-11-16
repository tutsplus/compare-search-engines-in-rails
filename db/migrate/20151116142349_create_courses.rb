class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.string :category
      t.float :duration
      t.datetime :published_at

      t.timestamps null: false
    end
  end
end
