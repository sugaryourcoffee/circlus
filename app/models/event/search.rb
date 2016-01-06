class Event::Search
  
  DATE_REGEX = /^(2\d{3})-(0[1-9]|1[0-2])-(0[1-9]|1[1-9]|2[1-9]|3[01])/
  QUERY = "lower(title) like :title or " +
          "lower(events.description) like :description or " +
          "lower(venue) like :venue or " +
          "start_date = :date"

  attr_reader :result

  def initialize(events, search_term)
    build_query_params(search_term.downcase)
    @result = events.where(QUERY, @args).order(@order)
  end

  private

    def build_query_params(search_term)
      search_term =~ DATE_REGEX ? date_params(search_term) 
                                : name_params(search_term)
      build_order(search_term)
    end

    def name_params(search_term)
      @args = { title: contains(search_term), 
                description: contains(search_term), 
                venue: begins_with(search_term),
                date: Time.now.strftime("%Y-%m-%d") }

    end

    def date_params(search_term)
      date = search_term.scan(DATE_REGEX).first.map! { |d| d.to_i }
      date_term = Date.valid_date?(*date) ? Date.new(*date) : Time.now

      @args = { title: begins_with(search_term), 
                description: contains(search_term), 
                venue: contains(search_term),
                date: date_term }
    end

    def build_order(search_term)
      @order = "start_date desc, title, venue, description asc "
    end

    def begins_with(search_term)
      search_term + "%"
    end

    def contains(search_term)
      "%" + search_term + "%"
    end

end
