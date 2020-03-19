class DeveloperShowcaseController
  BASE_URL = "https://developer.spotify.com"

  def initialize
    puts "*** Spotify Developer Showcase ***"

    scraper = DeveloperShowcaseScraper.new(BASE_URL)
    @developer_showcase = scraper.scrape
  end

  def call
    input = ""
    while input != "exit"
      puts "What do you want to do?"
      input = gets.strip
      case input
      when "test"
        test_projects
      when "exit"
        puts "Closing down..."
        break
      end
    end
  end

  def test_projects
    @developer_showcase.projects.each.with_index(1) do |project, i|
      puts "#{i}. #{project.title}"
    end
  end
end
