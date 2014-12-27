# encoding: utf-8
module ADNCV
  class App < Thor
    package_name "adncv"
    require_relative "display"
    require_relative "data"

    desc "display", "Show your account statistics (-d)"
    map "-d" => :display
    option :full, aliases: "-f", type: :boolean, desc: "Display full details: links, users, etc"
    def display(file)
      analyze(file)
      @display.show(@data, options)
    end

    desc "export", "Export your account statistics (-e)"
    map "-e" => :export
    def export(file)
      analyze(file)
      @data.export
      @display.exported(@data.export_path)
    end

    desc "version", "Show the current version (-v)"
    map "-v" => :version
    def version
      display = Display.new
      display.version
    end

    private

    def analyze(file)
      @data = Data.new
      @display = Display.new
      @display.analyzing
      @data.extract(file)
    end

  end
end