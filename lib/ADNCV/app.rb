# encoding: utf-8
module ADNCV
  class App < Thor
    package_name "ADNCV"

    desc "version", "Show the current version (-v)"
    map "-v" => :version
    def version
      puts VERSION
    end

  end
end