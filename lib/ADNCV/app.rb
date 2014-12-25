# encoding: utf-8
module ADNCV
  class App < Thor
    package_name "ADNCV"
    require_relative "display"
    require_relative "data"

    desc "display", "Extract"
    map "-d" => :display
    def display(file)
      data = Data.new
      display = Display.new
      display.analyzing
      data.extract(file)
      display.done
      data.display
    end

    desc "export", "Export"
    map "-e" => :export
    def export(file)
      data = Data.new
      display = Display.new
      display.analyzing
      data.extract(file)
      display.done
      data.export
      display.exported(data.export_path)
    end

    desc "version", "Show the current version (-v)"
    map "-v" => :version
    def version
      display = Display.new
      display.version
    end

  end
end