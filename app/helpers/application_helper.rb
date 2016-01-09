module ApplicationHelper

  def if_content(content, br=true)
    unless content.nil? or content.empty?
      content << tag(:br) if br
      content.html_safe
    end
  end

  def if_phone(phone, br=true)
    unless phone.nil? or phone.empty?
      content = "<i class='glyphicon glyphicon-phone-alt'></i> #{phone}"
      content << tag(:br) if br
      content.html_safe
    end
  end

  def if_email(email, br=true)
    unless email.nil? or email.empty?
      content = "<i class='glyphicon glyphicon-envelope'></i> #{mail_to email}"
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

  def if_blockquote(quote, footer)
    unless quote.nil? or quote.empty?
      content = <<-HTML
        <blockquote><p>#{quote}</p>
          <footer>Information about 
            <cite>#{footer}</cite>
          </footer>
        </blockquote>
      HTML
      content.html_safe
    end
  end

end
