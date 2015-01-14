# encoding: utf-8
module ADNCV
  class App < Thor
    package_name "adncv"
    require_relative "display"
    require_relative "data"

    desc "display", "Show your account statistics (-d)"
    map "-d" => :display
    option :full, aliases: "-f", type: :boolean, desc: "Display full details: links, users, etc", default: false
    # option :messages, aliases: "-m", type: :boolean, desc: "Reads messages file instead of posts file", default: false
    option :table, aliases: "-t", type: :boolean, desc: "Displays data in a table", default: true
    def display(file)
      analyze(file, options)
      @display.show(@data, options)
    end

    desc "export", "Export your account statistics (-e)"
    map "-e" => :export
    option :path, aliases: "-p", type: :string, desc: "Specify the path for the exported file"
    # option :messages, aliases: "-m", type: :boolean, desc: "Reads messages file instead of posts file"
    def export(file)
      analyze(file, options)
      @data.export(options)
      @display.exported(@data.export_path)
    end

    desc "version", "Show the current version (-v)"
    map "-v" => :version
    def version
      display = Display.new
      display.version
    end

    private

    def analyze(file, options)
      @data = Data.new
      @display = Display.new
      @display.analyzing
      @data.extract(file, options)
    end

  end
end