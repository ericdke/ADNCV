# encoding: utf-8
module ADNCV
  class App < Thor
    package_name "ADNCV"

    desc "version", "Show the current version (-v)"
    map "-v" => :version
    def version
      display = Display.new
      display.version
    end

  end
end