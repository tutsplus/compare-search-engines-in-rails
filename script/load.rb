require "bundler"
Bundler.require(:script)
require "csv"

DB = Sequel.connect "sqlite://db/development.sqlite3"

courses = CSV.read "db/data.csv", col_sep: "|"

courses.each do |course|
  DB[:courses].insert(
    title: course[0],
    category: course[1],
    published_at: course[2],
    duration: course[3],
    created_at: Time.now,
    updated_at: Time.now
  )
end
