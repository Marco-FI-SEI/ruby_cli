class InvalidType < StandardError; end

class DeveloperShowcase
  attr_accessor :projects

  def initialize
    @projects = []
  end

  def projects
    @projects.dup.freeze
  end

  def add_project(project)
    if !project.is_a?(Project)
      raise InvalidType, "Must be a Project!"
    else
      @projects << project
    end
  end

  def check_project_sites_status
    @report = {}

    @projects.each do |project|
      @link = project.project_link
      title = project.title
      @report[title] = {}
      @report[title][:authors] = get_authors_as_strings(project.authors)
      @report[title][:site_response] = query_site
    end
  end

  def get_authors_as_strings(authors_arr)
    if authors_arr.length > 1
      authors_string = authors_arr.join(" & ")
    else
      authors_string = authors_arr.first
    end

    authors_string
  end

  def query_site
    max_retries = 3
    retry_number = 0

    begin
      response = HTTParty.get(@link, { read_timeout: 1, open_timeout: 1 })
      message = response.message
    rescue HTTParty::Error, SocketError, Net::ReadTimeout, Net::OpenTimeout => error
      if retry_number < max_retries
        retry_number += 1
        retry
      else
        message = "This website is unavailable"
      end
    end
    message
  end

  def render_site_health_check_report
    rows = []
    # k = project names, v = authors, site_response
    @report.each do |k, v|
      row = []
      row << k
      row << v[:authors]
      row << v[:site_response]

      rows << row
    end

    header = ["Project", "Authors", "Response"]
    table = TTY::Table.new header, rows

    puts table.render(:unicode, multiline: true)
  end
end
