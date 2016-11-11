require 'csv'

desc "Run the initial import for councils"
task import_councils: [:environment] do
  links = []

  CSV.foreach("lib/tasks/import_councils.csv", headers: true) do |row|
    next if row.empty?

    puts "Creating recommended link for #{row.inspect}"

    link = RecommendedLink.new(
      title: row['Title'],
      link: row['Link'],
      description: "Website of #{row['Title']}",
      keywords: row['Title'],
      comment: "Imported via developer task. Source: https://github.com/alphagov/recommended-links/blob/211ee1e15a0d3467da80e16d25bc898a0a5d17e2/data/index/recommended-link/councils.csv"
    )

    if link.valid?
      links.push(link)
    else
      puts "Error(s) on line #{$.} of the CSV file: #{link.errors.messages}"
    end
  end

  puts "Saving all recommended links to the database"
  RecommendedLink.transaction do
    links.each(&:save!)
  end
end
