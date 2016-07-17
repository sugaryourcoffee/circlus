module PdfTemplate::Printer

  PAGE_NUMBERING = ["<page>", "Page <page>", 
                    "<page>/<total>", "Page <page> of <total>"]
  DATE_FORMATS   = ["%d.%m.%Y - %H:%M:%S", "%d.%m - %H:%M", "%d.%m.%Y"]

  def to_pdf(template)
    pdf_template = PdfTemplate.find(template.to_i)

    orientation = if pdf_template.orientation.nil? 
                    :portrait 
                  else
                    pdf_template.orientation.to_sym
                  end

    pdf = Prawn::Document.new(page_size: "A4", page_layout: orientation)

    row_class = pdf_template.column_class.demodulize.downcase.pluralize
    header = pdf_template.header
    footer = pdf_template.footer
    values, headers, sizes = pdf_template.header_columns.map do |c| 
      [c.content, c.title, (c.size.nil? || c.size.empty?) ? 5 : c.size.to_i]
    end.transpose

    row_number = 0

    row_data = send(row_class).map do |klass|
      values.map do |v|
        if v.nil? || v.empty?
          ""
        elsif v == "#"
          sprintf("%d", (row_number += 1))
        else
          initial, *messages = v.split('.')
          messages.inject(klass.send(initial)) { |c, m| c.send(m) }.to_s
        end
      end if values
    end

    # header
    if header
      page_section(pdf, header.left, pdf.bounds.top_left, :left)
      page_section(pdf, header.middle, pdf.bounds.top_left, :center)
      page_section(pdf, header.right, pdf.bounds.top_left, :right)
    end

    # content
    pdf.move_down 15


    if row_data.empty?
      pdf.move_down 15
      pdf.text "No data available!"
    else
      pdf.table([headers, *row_data], cell_style: { size: 8, padding: 2 }, 
               column_widths: calculate_width(pdf, row_data, sizes)) do |t| 
        t.header = true
        t.columns(headers.index("#")).align = :right if headers.index("#")
        t.row(0).style(background_color: '44844', text_color: 'fffffff')
        t.row(0).font_style = :bold
        t.row(0).columns(0..headers.length).align = :center
      end
    end

    # footer
    if footer
      page_section(pdf, footer.left, [pdf.bounds.left, 12], :left)
      page_section(pdf, footer.middle, [pdf.bounds.left, 12], :center)
      page_section(pdf, footer.right, [pdf.bounds.left, 12], :right)
    end

    pdf.render
  end

  private

    def page_section(pdf, content, position, horizontal)
      options = {
        at: position,
        width: pdf.bounds.width,
        align: horizontal,
        single_line: true,
        size: 10
      }

      if PAGE_NUMBERING.include? content
        pdf.number_pages(content, options) 
      else
        value = if DATE_FORMATS.include? content
                  Time.now.strftime(content)
                else
                  if content.nil?
                    "no data"
                  else 
                    content.empty? ? "" : send(content).to_s
                  end
                end
        pdf.repeat(:all) { pdf.text_box(value, options) }
      end
    end

    def calculate_width(pdf, values, sizes)
      column_sizes = [values.transpose.map do |c| 
                       c.inject { |m, v| m > v ? m : v }.length
                     end,
                     sizes].transpose.map { |v| v.max }

      pdf_width = pdf.bounds.width
      column_sizes_sum = column_sizes.sum
      column_sizes.map { |value| value * pdf_width / column_sizes_sum }
    end

    def get_value(value)
       
    end
end
