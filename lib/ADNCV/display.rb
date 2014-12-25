# encoding: utf-8
module ADNCV
  class Display

    def initialize
      @thor = Thor::Shell::Color.new
    end

    def version
      @thor.say_status :version, "#{VERSION}", :red
    end

    def analyzing
      @thor.say_status :working, "Analyzing JSON file", :yellow
    end

    def done
      @thor.say_status :done, "Parsed and sorted", :green
    end

  end
end