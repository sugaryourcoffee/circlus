class Organization::Search
  
  QUERY = "lower(name) like :name or " +
          "lower(street) like :street or " +
          "lower(town) like :town or " +
          "lower(country) like :country or " +
          "lower(email) like :email or " +
          "lower(website) like :website"
 
  attr_reader :result

  def initialize(organizations, search_term)
    build_query_params(search_term.downcase)
    @result = organizations.where(QUERY, @args).order(@order)
  end

  private

    def build_query_params(search_term)
      if search_term =~ /[:\.\/]/ 
        website_params(search_term) 
      elsif search_term =~ /@/
        email_params(search_term)
      else
        name_params(search_term)
      end

      build_order(search_term)
    end

    def name_params(search_term)
      @args = { name: begins_with(search_term), 
                street: begins_with(search_term), 
                town: begins_with(search_term),
                country: begins_with(search_term),
                email: begins_with(search_term),
                website: contains(search_term) }

    end

    def website_params(search_term)
      # This regex would extract the website name without http://www. and .com
      # (?<=\/www|\/www\.)\w+|(?<=\/)\w+(?=\.\w+$)|\w+(?=\.\w+$|\.$)

      # This regex removes everything except the website name
      # ^.*\/+|.*www\.|\..*$
      name_term = search_term.gsub(/^.*\/+|.*www\.|\..*$/, "")

      @args = { name: begins_with(name_term), 
                street: begins_with(name_term), 
                town: begins_with(name_term),
                country: begins_with(name_term),
                email: begins_with(name_term),
                website: begins_with(search_term) }
    end

    def email_params(search_term)
      name_term = search_term.gsub(/@.*/, "")

      @args = { name: begins_with(name_term), 
                street: begins_with(name_term), 
                town: begins_with(name_term),
                country: begins_with(name_term),
                email: begins_with(name_term),
                website: begins_with(search_term) }
    end

    def build_order(search_term)
      @order = "email like " +
               ActiveRecord::Base.connection.quote(search_term) +
               ", website like " + 
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
