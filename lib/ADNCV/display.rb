# encoding: utf-8
module ADNCV
  class Display

    def initialize
      @thor = Thor::Shell::Color.new
    end

    def version
      @thor.say_status :version, "#{VERSION}", :red
    end

  end
end