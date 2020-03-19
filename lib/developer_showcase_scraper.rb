class DeveloperShowcaseScraper
  attr_accessor :developer_showcase, :doc

  def initialize(base_url)
    @base_url = base_url
    @developer_showcase = DeveloperShowcase.new
    @doc = Nokogiri::HTML(open("#{base_url}/community/showcase/"))
  end

  def scrape
    get_project_links
    scrape_projects
    @developer_showcase
  end

  def get_project_links
    @project_links = @doc.css("div.tile-container-3-col a[href]").map { |element| element["href"] }
  end

  def scrape_projects
    @project_links.each do |link|
      # make link available to scrape_project_page
      @link = link
      @project_url = "#{@base_url}#{link}"
      @project_page = Nokogiri::HTML(open(@project_url))

      scrape_project_page
      add_project_to_showcase unless @project_properties.empty?
    end
  end

  def scrape_project_page
    project_properties = {}

    if is_page_valid?
      project_properties[:url] = @link
      project_properties[:title] = @project_page.css(".display-1").text.strip
      project_properties[:description] = @project_page.css(".showcase-description").text.strip

      website_link = @project_page.at_css('a:contains("Website")')
      project_properties[:project_link] = website_link["href"]

      get_project_authors
      project_properties[:authors] = @authors
    end

    @project_properties = project_properties
  end

  def is_page_valid?
    # page link always present so not checked
    if @project_page.css(".display-1") &&
       @project_page.css(".showcase-description") &&
       @project_page.at_css('a:contains("Website")') &&
       @project_page.search("div[class='post-content'] li:first-child")
      return true
    end

    false
  end

  def get_project_authors
    # two authors usually represented as: "Submitted by: Aliza Aufrichtig & Edward Lee"
    authors_list_item_text = @project_page.search("div[class='post-content'] li:first-child").text.strip

    # remove "Submitted by: "
    authors_names = authors_list_item_text.gsub("Submitted by: ", "")
    # get authors into array without whitespace
    if authors_names.include?("&")
      @authors = authors_names.split("&").map { |author| author.strip }
    else
      @authors = [authors_names.strip]
    end

    @authors
  end

  def add_project_to_showcase
    @developer_showcase.add_project(Project.new_from_showcase(@project_properties))
  end
end
