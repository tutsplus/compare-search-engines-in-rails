class SunspotSearcher
  attr_reader :params, :courses
  def call params
    @params = params
    @courses = if params[:q].present?
      simple_search
    else
      complex_search
    end
    self
  end

  def simple_search
    Course.search { fulltext params[:q] }.results
  end

  def complex_search
    Course.search do
      if params[:search][:title].present?
        fulltext params[:search][:title] { fields :title }
      end

      if params[:search][:category].present?
        fulltext params[:search][:category] { fields :category }
      end

      if params[:search][:duration_start].present?
        with(:duration).greater_than params[:search][:duration_start]
      end

      if params[:search][:duration_end].present?
        with(:duration).less_than params[:search][:duration_end]
      end

      if params[:search][:published_at_last].present?
        with(:published_at).greater_than(
          1.send(params[:search][:published_at_last].to_sym).ago
        )
      else
        if params[:search][:published_at_start].present?
          with(:published_at).greater_than params[:search][:published_at_start]
        end

        if params[:search][:published_at_end].present?
          with(:published_at).less_than params[:search][:published_at_end]
        end
      end

    end.results
  end
end
