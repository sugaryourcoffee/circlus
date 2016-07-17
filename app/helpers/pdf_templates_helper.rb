module PdfTemplatesHelper
  def templates(klass)
    PdfTemplate.all.where('associated_class = ?', klass)
                   .collect { |t| [t.title, t.id] }
  end
end
