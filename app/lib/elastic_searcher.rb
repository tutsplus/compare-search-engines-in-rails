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
          must: matches
        }
      }
    }).records
  end
end


