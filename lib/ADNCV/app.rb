# encoding: utf-8
module ADNCV
  class App < Thor
    package_name "ADNCV"
    require_relative "display"
    require_relative "data"

    desc "extract", "Extract"
    map "-e" => :extract
    def extract(file)
      data = Data.new
      display = Display.new
      display.analyzing
      data.extract(file)
      display.done
      puts data.inspect
    end

    desc "version", "Show the current version (-v)"
    map "-v" => :version
    def version
      display = Display.new
      display.version
    end

  end
end