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
end
