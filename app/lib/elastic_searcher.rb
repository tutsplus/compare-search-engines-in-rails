class ElasticSearcher
  attr_reader :courses

  def call params
    @params = params
    @courses = if params[:search][:title].present? || params[:search][:category].present?
      complex_search
    else
      simple_search
    end

    self
  end

  protected

  attr_reader :params

  def simple_search
    Course.search(params[:q]).records
  end

  def complex_search
    title = params[:search][:title]
    category = params[:search][:category]

    matches = []
    matches << { wildcard: { title: title } } unless title.empty?
    matches << { wildcard: { category: category } } unless category.empty?

    published_at_filter = if params[:search][:published_at_last].empty?
      published_at_range
    else
      published_at_last
    end

    Course.search({
      query: {
        bool: {
          must: [ matches, duration_range, published_at_filter ].flatten
        }
      }
    }).records
  end

  def duration_range
    duration_start = params[:search][:duration_start]
    duration_end   = params[:search][:duration_end]

    duration_start = nil if duration_start.empty?
    duration_end   = nil if duration_end.empty?

    {
      range: {
        duration: {
          gte: duration_start,
          lte: duration_end
        }
      }
    }
  end

  def published_at_range
    published_at_start = params[:search][:published_at_start]
    published_at_end   = params[:search][:published_at_end]

    published_at_start = nil if published_at_start.empty?
    published_at_end   = nil if published_at_end.empty?

    {
      range: {
        published_at: {
          gte: published_at_start,
          lte: published_at_end,
          format: "yyyy/MM/dd"
        }
      }
    }
  end

  def published_at_last
    table = {
      "week" => 7,
      "month" => 30,
      "year" => 365
    }
    number = table[params[:search][:published_at_last]]

    {
      range: {
        published_at: {
          gte: "now-#{number}d/d"
        }
      }
    }
  end
end
