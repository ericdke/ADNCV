# encoding: utf-8
module ADNCV
  class Display

    def initialize
      @thor = Thor::Shell::Color.new
    end

    def init_table(title = 'ADNCV')
      Terminal::Table.new do |t|
        t.style = { :width => 80 }
        t.title = title
      end
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
      @thor.say_status :version, "#{VERSION}", :yellow
      @thor.say_status :source, "http://github.com/ericdke/ADNCV", :green
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
      @thor.say_status :done, "Data exported in #{filename}\n", :green
    end

    def clear_screen
      puts "\e[H\e[2J"
    end

    def show(data, options)
      clear_screen()
      if options[:table]
        table = init_table("Your App.net stats")
        table << ["Total posts", data.count]
        table << ["Without mentions", data.without_mentions]
        table << ["Directed to a user", data.leadings]
        table << ["Containing mentions but not directed", data.mentions_not_directed]
        table << ["Containing mentions and are replies", data.replies]
        table << ["Containing mentions and are not replies", data.mentions_not_replies]
        table << ["Containing links", data.with_links]
        table << ["Times your posts have been reposted", data.reposts]
        table << ["Times your posts have been starred", data.stars]
        table << ["Times your posts have been replied", data.been_replied]
        table << ["Users you've posted directly to", data.directed_users.size]
        table << ["Users you've mentioned", data.names.size]
        puts "#{table}\n\n"
        table = init_table("The #{data.clients.size} clients you've posted with")
        data.all_clients.reverse.each do |k,v|
          table << [k,v]
        end
        puts "#{table}\n\n"
        if options["full"]
          puts "- Your posted links:\n"
          data.all_links.each {|link| puts link}
          puts "\n\n"
          table = init_table("Users you've posted directly to")
          data.all_directed.uniq.reverse.each {|k,v| table << ["@#{k}",v]}
          puts "#{table}\n\n"
          table = init_table("Users you've mentioned")
          data.all_mentioned.reverse.each {|k,v| table << ["@#{k}",v]}
          puts "#{table}\n\n"
          table = init_table("Your monthly posting frequency")
          table.headings = ["Year", "Month", "Posts"]
          data.freq.each do |k,v|
            table << [k[0], k[1], v]
          end
          puts "#{table}\n\n"
        end
      else
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
          puts "Your posted links: #{data.all_links.join(', ')}" + "\n\n"
          puts "Users you've posted directly to: #{data.directed_users.reverse.join(', ')}" + "\n\n"
          puts "Users you've mentioned: #{data.names.reverse.join(', ')}" + "\n\n"
          puts "Your monthly posting frequency:\n\n"
          @thor.print_table([["Year", "Month", "Posts\n"]])
          puts "------------------"
          @thor.print_table(data.freq)
          puts "\n"
        end
      end
    end

  end
end