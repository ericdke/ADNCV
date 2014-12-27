# encoding: utf-8
module ADNCV
  class Display

    def initialize
      @thor = Thor::Shell::Color.new
    end

    def banner
      <<-ADNCV
   ___   ___  _  ________   __
  / _ | / _ \\/ |/ / ___/ | / /
 / __ |/ // /    / /__ | |/ / 
/_/ |_/____/_/|_/\\___/ |___/  
                              
      ADNCV
    end

    def version
      puts banner()
      @thor.say_status :version, "#{VERSION}", :red
      puts "\n"
    end

    def analyzing
      puts "\n"
      @thor.say_status :working, "Analyzing JSON file", :yellow
    end

    def done
      @thor.say_status :done, "Parsed and sorted", :green
    end

    def exported(filename)
      @thor.say_status :done, "Data exported in #{filename}", :green
    end

    def clear_screen
      puts "\e[H\e[2J"
    end

    def show(data, options)
      clear_screen()
      puts "Total posts:".ljust(50) + "#{data.count}" + "\n\n"
      puts "Without mentions:".ljust(50) + "#{data.without_mentions}" + "\n\n"
      puts "Directed to a user:".ljust(50) + "#{data.leadings}" + "\n\n"
      puts "Containing mentions but not directed:".ljust(50) + "#{data.mentions_not_directed}" + "\n\n"
      puts "Containing mentions and are replies:".ljust(50) + "#{data.replies}" + "\n\n"
      puts "Containing mentions and are not replies:".ljust(50) + "#{data.mentions_not_replies}" + "\n\n"
      puts "Containing links:".ljust(50) + "#{data.with_links}" + "\n\n"
      puts "Times your posts have been reposted:".ljust(50) + "#{data.reposts}" + "\n\n"
      puts "Times your posts have been starred:".ljust(50) + "#{data.stars}" + "\n\n"
      puts "Times your posts have been replied:".ljust(50) + "#{data.been_replied}" + "\n\n"
      puts "Users you've posted directly to:".ljust(50) + "#{data.directed_users.size}" + "\n\n"
      puts "Users you've mentioned:".ljust(50) + "#{data.names.size}" + "\n\n"
      puts "You've posted with #{data.clients.size} clients:\n\n#{data.sources.reverse.join(', ')}" + "\n\n"
      if options["full"]
        puts "Your posted links:".ljust(50) + "#{data.all_links.join(', ')}" + "\n\n"
        puts "Users you've posted directly to: #{data.directed_users.reverse.join(', ')}" + "\n\n"
        puts "Users you've mentioned: #{data.names.reverse.join(', ')}" + "\n\n"
      end
    end

  end
end