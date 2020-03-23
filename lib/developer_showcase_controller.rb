class DeveloperShowcaseController
  BASE_URL = "https://developer.spotify.com"

  def initialize
    @pastel = Pastel.new
    puts @pastel.green.underline("*** Spotify Developer Showcase Tester ***")

    spinner = TTY::Spinner.new("[:spinner] Scraping showcase page...", format: :bouncing_ball)
    spinner.auto_spin

    @scraper = DeveloperShowcaseScraper.new(BASE_URL)
    @developer_showcase = @scraper.scrape

    spinner.stop("Done!")
    sleep(1)
  end

  def call
    @prompt = TTY::Prompt.new
    main_menu
  end

  def main_menu
    system("clear")

    menu_choice = @prompt.select("\n",
                  "1. Test projects",
                  "2. Test listings",
                  "3. Exit"
                )

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

  def is_every_project_scraped?
    @scraper.get_scrape_success_report
    next_action
  end

  def test_projects
    spinner = TTY::Spinner.new("[:spinner] Testing status of project sites...", format: :bouncing_ball)
    spinner.auto_spin

    @developer_showcase.check_project_sites_status

    spinner.stop("Done!")
    sleep(1)
    @developer_showcase.render_site_health_check_report

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
