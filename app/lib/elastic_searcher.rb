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

    Course.search({
      query: {
        bool: {
          must: [ matches, duration_range ].flatten
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
end


