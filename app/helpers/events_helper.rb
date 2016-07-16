module EventsHelper

  def event_templates
    PdfTemplate.all.where('associated_class = ?', 'Event')
                   .collect { |t| [t.title, t.id] }
  end

end
