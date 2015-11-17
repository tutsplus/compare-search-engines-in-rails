require "bundler"
Bundler.require :script
require "csv"
require "time"
require "net/http"

URL = "http://code.tutsplus.com/courses"
PAGE_COUNT = 20

CSV.open("db/data.csv", "w", col_sep: "|") do |csv|
  1.upto(PAGE_COUNT) do |number|
    print "Scraping page #{number}..."

    page = Nokogiri::HTML(Net::HTTP.get(URI(URL + "?page=#{number}")))
    courses = page.css(".products__course")

    courses.each do |course|
      title        = course.css(".products__title").text
      category     = course.css(".products__primary-category").text
      published_at = Time.parse(course.css(".products__publication-date").
                     attribute("datetime").text)
      duration     = course.css(".products__duration").text.to_f

      csv << [ title, category, published_at, duration]

    end

    puts "Done."
  end
end
