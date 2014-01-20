require "mechanize"

require "tempfile"

# Make a pdftoxml method just like in Python
module PdfHelper
  def self.pdftoxml(data, options = "")
    # Write data to a temporary file (with a pdf extension)
    src = Tempfile.new(['pdftohtml_src.', '.pdf'])
    dst = Tempfile.new(['pdftohtml_dst.', '.xml'])

    src.write(data)
    src.close

    command = "/usr/bin/pdftohtml -xml -nodrm -zoom 1.5 -enc UTF-8 -noframes #{options} #{src.path} #{dst.path}"
    # Would be good to turn off output here
    system(command)

    result = dst.read

    # Cleanup
    src.unlink
    dst.unlink

    result
  end

  def self.find_column_no(columns, left, right)
    columns.find_index do |c|
      (left >= c[0] && left <= c[1]) || (right >= c[0] && right <= c[1]) || (left <= c[0] && right >= c[1])
    end
  end

  def self.extract_columns_from_pdf_text(texts)
    columns = []
    texts.each do |t|
      # See if there is any overlap between the current bit of text and any of the
      # preexisting columns
      left = t["left"].to_i
      right = t["left"].to_i + t["width"].to_i
      i = find_column_no(columns, left, right)
      if i
        puts "#{t.inner_text} is in column #{i}"
        # Update the boundary of the column based on the current text position
        columns[i] = [[left, columns[i][0]].min, [right, columns[i][1]].max]
      else
        puts "#{t.inner_text} is in new column"
        columns << [left, right]
      end
    end
    # And make sure the results are in order
    columns.sort{|a,b| a[0] <=> b[0]}
  end

  def self.extract_indices_from_pdf_text(texts, columns = nil)
    columns = extract_columns_from_pdf_text(texts) if columns.nil? 
    top, left, width = nil, nil, nil
    x, y = 0, 0
    texts = texts.map do |t|
      left = t["left"].to_i
      right = left + t["width"].to_i
      new_x = find_column_no(columns, left, right)
      # If we're back at the beginning of a row this is a new row
      y += 1 if new_x == 0 && x > 0
      x = new_x unless new_x.nil? 
      [x, y, t.inner_text]
    end
  end

  # Can pass in the optional columns if the automated finding of columns
  # doesn't work properly for some reason
  def self.extract_table_from_pdf_text(texts, columns = nil)
    texts = extract_indices_from_pdf_text(texts, columns)
    # Find the the range of indices
    max_x, max_y = texts.first
    texts.each do |t|
      max_x = [max_x, t[0]].max
      max_y = [max_y, t[1]].max
    end
    # Create an empty 2d array
    result = Array.new(max_y + 1) { |i| Array.new(max_x + 1) }
    texts.each do |t|
      x, y, text = t
      if result[y][x].nil? 
        result[y][x] = text
      else
        result[y][x] += "\n" + text
      end
    end
    result
  end
end



info_url = "http://www.perth.wa.gov.au/planning-development/planning-and-building-tools/building-and-development-applications-received"

def clean_whitespace(a)
  a.gsub("\n", " ").squeeze(" ").strip
end

def extract_applications_from_pdf(content, info_url)
  info_url = "http://www.perth.wa.gov.au/planning-development/planning-and-building-tools/building-and-development-applications-received"

  doc = Nokogiri::XML(PdfHelper.pdftoxml(content))
  doc.search('page').each do |p|
    # Have to hardcode the column extents here because the automated finding doesn't work because
    # some of the text from the different columns overlap each other. Ugh...
    columns = [[92, 342], [343, 585], [645, 696], [726, 775], [825, 882], [908, 911]]

    PdfHelper.extract_table_from_pdf_text(p.search('text[font="2"]'), columns).each do |row|
      record = {
        "date_received" => Date.strptime(row[0].split(" ")[0], "%d/%m/%Y").to_s,
        "address" => clean_whitespace(row[0].split(" ")[1..-1].join(" ")),
        "description" => clean_whitespace(row[1]),
        "council_reference" => row[4].strip,
        "date_scraped" => Date.today.to_s,
        "info_url" => info_url,
        "comment_url" => info_url,
      }

      if (ScraperWiki.select("* from swdata where `council_reference`='#{record['council_reference']}'").empty? rescue true)
        ScraperWiki.save_sqlite(['council_reference'], record)
      else
        puts "Skipping already saved record " + record['council_reference']
      end
    end
  end
end

agent = Mechanize.new
page = agent.get(info_url)
# Only get the 4 most recent week's applications
page.search("a").find_all{|a| a.inner_text =~ /For the period/}[0..3].each do |a|
  page = agent.get(a["href"])
  extract_applications_from_pdf(page.content, info_url)
end
