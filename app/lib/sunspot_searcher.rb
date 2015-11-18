class SunspotSearcher
  attr_reader :params, :courses
  def call params
    @params = params
    @courses = Course.search { fulltext params[:q] }.results
    self
  end
end
