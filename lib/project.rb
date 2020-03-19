class Project
  attr_accessor :url, :title, :description, :project_link, :authors

  @@all = []

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end

  def self.new_from_showcase(properties)
    Project.new.tap do |project|
      properties.each do |k, v|
        project.send("#{k}=", v)
      end
    end
  end
end
