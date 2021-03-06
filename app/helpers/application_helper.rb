module ApplicationHelper

  EMAIL_PATTERN = /\A[\w!#\$%&'*+\/=?`{|}~^-]+(?:\.[\w!#\$%&'*+\/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}\Z/ 
  WEBSITE_PATTERN = /\Ahttps?:\/\/(\w+[\w\d\-_]*(\/|\.)?)*\w{2,4}(:\d+)?\z/

  def distribution_list(recipients)
    main = recipients.where.not(email: '').pluck(:email)
    recipients_ids = recipients.pluck(:id)
    other = Email.where(member_id: recipients_ids).where.not(address: '')
                 .pluck(:address)
    (main << other).flatten.uniq.join(';')
  end

  def distribution_with_content(recipients, options={subject: "", body: ""})
    email = distribution_list(recipients)
    email << "&subject=#{options[:subject]}" unless options[:subject].blank?
    email << "&body=#{options[:body]}" unless options[:body].blank?
  end

  def if_content(content, br=true)
    unless content.nil? or content.empty?
      content << tag(:br) if br
      content.html_safe
    end
  end

  def phone_number(number)
    clean_number = number.gsub(/[^\+\d]/, "")
    "<a href=\"tel:#{clean_number}\"> #{number}</a>" 
  end

  def if_mobile(phone, br=true, category=nil)
    unless phone.nil? or phone.empty?
      content = "<i class='glyphicon glyphicon-phone'></i>"
      content << phone_number(phone)
      content << " (#{Phone::CATEGORIES[category.to_i][0]})" if category
      content << tag(:br) if br
      content.html_safe
    end
  end

  def if_phone(phone, br=true)
    unless phone.nil? or phone.empty?
      content = "<i class='glyphicon glyphicon-phone-alt'></i>"
      content << phone_number(phone)
      content << tag(:br) if br
      content.html_safe
    end
  end

  def if_email(email, br=true, category=nil)
    unless email.nil? or email.empty?
      content = "<i class='glyphicon glyphicon-envelope'></i> #{mail_to email}"
      content << " (#{Email::CATEGORIES[category.to_i][0]})" if category
      content << tag(:br) if br
      content.html_safe
    end
  end

  def if_website(website, br=true, blank=true)
    unless website.nil? or website.empty?
      content = "<i class='glyphicon glyphicon-globe'></i> "
      if blank
        content << "#{link_to website, website, target: '_blank'}"
      else
        content << "#{link_to website, website}"
      end
      content << tag(:br) if br
      content.html_safe
    end
  end

  def if_blockquote(quote, footer, show_footer=false)
    unless quote.nil? or quote.empty?
      if show_footer
        <<-HTML
          <blockquote><p>#{quote}</p>
            <footer>Information about 
              <cite>#{footer}</cite>
            </footer>
          </blockquote>
        HTML
      else
        <<-HTML
          <blockquote><p>#{quote}</p></blockquote>
        HTML
      end.html_safe
    end
  end

  def format_date(date)
    l date if date
  end

  def format_time(time, format="%H:%M")
    time.strftime(format) if time
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |g|
      render(association.to_s.singularize + "_fields", g: g)
    end
    link_to(name, '#', class: 'add_fields btn btn-success',
            data: {id: id, fields: fields.gsub("\n", "")})
  end
end
