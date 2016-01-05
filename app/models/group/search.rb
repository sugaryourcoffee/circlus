class Group::Search
  
  QUERY = "lower(name) like :name or " +
          "lower(website) like :website or " +
          "lower(description) like :description"

  attr_reader :result

  def initialize(search_term)
    build_query_params(search_term.downcase)
    @result = Group.where(QUERY, @args).order(@order)
  end

  private

    def build_query_params(search_term)
      search_term =~ /[:\.\/]/ ? website_params(search_term) 
                               : name_params(search_term)
      build_order(search_term)
    end

    def name_params(search_term)
      @args = { name: begins_with(search_term), 
                description: contains(search_term), 
                website: contains(search_term) }

    end

    def website_params(search_term)
      # (?<=\/www|\/www\.)\w+|(?<=\/)\w+(?=\.\w+$)|\w+(?=\.\w+$|\.$)
      # ^.*\/+|.*www\.|\..*$
      name_term = search_term.gsub(/^.*\/+|.*www\.|\..*$/, "")

      @args = { name: begins_with(name_term), 
                description: contains(name_term), 
                website: begins_with(search_term) }
    end

    def build_order(search_term)
      @order = "website like " + 
               ActiveRecord::Base.connection.quote(search_term) +
               "desc, name asc"
    end

    def begins_with(search_term)
      search_term + "%"
    end

    def contains(search_term)
      "%" + search_term + "%"
    end

end
