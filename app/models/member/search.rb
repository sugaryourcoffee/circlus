class Member::Search
  
  QUERY = "lower(organizations.name) like :name or " +
          "lower(members.first_name) like :first_name or " +
          "lower(members.email) like :email"

  attr_reader :result

  def initialize(members, search_term)
    build_query_params(search_term.downcase)
    @result = members.joins(:organization).where(QUERY, @args).order(@order)
  end

  private

    def build_query_params(search_term)
      search_term =~ /@/ ? email_params(search_term) : name_params(search_term)
      build_order(search_term)
    end

    def name_params(search_term)
      @args = { name: begins_with(search_term), 
                first_name: begins_with(search_term), 
                email: begins_with(search_term) }

    end

    def email_params(search_term)
      name_term = search_term.gsub(/@.*/, "")

      @args = { name: begins_with(name_term), 
                first_name: begins_with(name_term), 
                email: begins_with(search_term) }
    end

    def build_order(search_term)
      @order = "members.email like " + 
               ActiveRecord::Base.connection.quote(search_term) +
               "desc, organizations.name asc"
    end

    def begins_with(search_term)
      search_term + "%"
    end

end
