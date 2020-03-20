class DeveloperShowcaseController
  BASE_URL = "https://developer.spotify.com"

  def initialize
    spinner = TTY::Spinner.new("[:spinner] Scraping showcase page ...", format: :bouncing_ball)
    spinner.auto_spin
    @scraper = DeveloperShowcaseScraper.new(BASE_URL)
    @developer_showcase = @scraper.scrape
    spinner.stop("Done!")
    sleep(1)
  end

  def call
    @prompt = TTY::Prompt.new
    @pastel = Pastel.new
    main_menu
  end

  def main_menu
    system("clear")

    puts @pastel.green.underline("*** Spotify Developer Showcase Tester ***")
    menu_choice = @prompt.select("\n",
                                 "1. Test projects",
                                 "2. Test listings",
                                 "3. Exit")

    case menu_choice
    when "1. Test projects"
      test_projects
    when "2. Test listings"
      is_every_project_scraped?
    when "3. Exit"
      quit
    else
      puts "\nInvalid option, try again!\n"
    end
  end

  def test_projects
    @developer_showcase.projects.each.with_index(1) do |project, i|
      puts "#{i}. #{project.title}"
    end
  end

  def is_every_project_scraped?
    @scraper.get_scrape_success_report
    next_action
  end

  def next_action
    response = @prompt.select("\nReturn to menu or exit?", "Return to menu", "Exit")
    response === "Return to menu" ? main_menu : quit
  end

  def quit
    system("clear")
  end
end
