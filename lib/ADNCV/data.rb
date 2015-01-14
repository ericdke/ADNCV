# encoding: utf-8
module ADNCV
  class Data

    attr_reader :filename, :count, :leadings, :without_mentions, :mentions_not_directed, :replies, :mentions_not_replies, :with_links, :sources, :all_links, :directed_users, :names, :clients, :mentions, :all_clients, :all_mentioned, :reposts, :stars, :been_replied, :freq, :type, :all_directed
    attr_accessor :export_path

    # def initialize
      
    # end

    def extract(file, options = {})
      @filename = file
      @decoded = JSON.parse(File.read(file))
      
      if options["messages"]
        @type = :messages
        extract_messages(file)
      else
        @type = :posts
        extract_posts(file)
      end
    end

    def extract_messages(file)
      messages = Hash.new(0)
      @decoded.each do |message|
        messages[message["channel_id"]] += 1
      end
      puts JSON.pretty_generate(messages)

      #
      exit
    end

    def extract_posts(file)
      @count = @decoded.size
      links = []
      @mentions = 0
      @leadings = 0
      @replies = 0
      @with_links = 0
      @reposts = 0
      @stars = 0
      @been_replied = 0
      mentioned = Hash.new(0) 
      directed = Hash.new(0)
      is_reply = Hash.new(0)
      @clients = Hash.new(0)
      @freq = Hash.new(0)

      @decoded.each do |post|
        @clients[post["source"]["name"]] += 1
        m = post["entities"]["mentions"]
        l = post["entities"]["links"]
        unless m.empty?
          @mentions += 1
          first = m[0]["name"]
          if m[0]["is_leading"] == true
            @leadings += 1
            directed[first] += 1
            unless post["reply_to"].nil?
              @replies += 1
              is_reply[first] += 1
            end
          end
          m.each do |obj|
            mentioned[obj["name"]] += 1
          end
        end
        unless l.empty?
          @with_links += 1
          l.each do |link|
            links << link['url']
          end
        end
        unless post["num_reposts"].nil?
          @reposts += post["num_reposts"]
        end
        unless post["num_stars"].nil?
          @stars += post["num_stars"]
        end
        unless post["num_replies"].nil?
          @been_replied += post["num_replies"]
        end
        dd = Date.parse(post["created_at"])
        @freq[[dd.year, dd.month]] += 1
      end

      @all_directed = directed.sort_by {|k,v| v}
      @all_clients = @clients.sort_by {|k,v| v}
      @all_mentioned = mentioned.sort_by {|k,v| v}.uniq
      @all_links = links.uniq.sort
      @names = @all_mentioned.map {|k,v| "@#{k} (#{v})"}
      @sources = @all_clients.map {|k,v| "#{k} (#{v})"}
      @directed_users = @all_directed.uniq.map {|k,v| "@#{k} (#{v})"}

      @without_mentions = count - @mentions
      @mentions_not_directed = @mentions - @leadings
      @mentions_not_replies = @mentions - @replies
    end

    def export(options)
      root = if options["path"]
        options["path"]
      else
        Dir.home
      end

      @export_path = "#{root}/adncv_export.json"

      export = {
        meta: {
          created_at: Time.now,
          from_file: @filename,
          with_version: VERSION
        },
        data: {
          posts: {
            total: @count,
            data: [{
              without_mentions: @without_mentions,
              directed: @leadings,
              directed_to_unique_users: @directed_users.size,
              with_mentions_not_directed: @mentions_not_directed,
              with_mentions_are_replies: @replies,
              with_mentions_are_not_replies: @mentions_not_replies,
              with_links: @with_links,
              have_been_reposted: @reposts,
              have_been_starred: @stars,
              have_been_replied: @been_replied,
              posts_per_month: @freq
            }]
          },
          users: {
            total: @all_mentioned.size,
            data: @all_mentioned.reverse
          },
          clients: {
            total: @all_clients.size,
            data: @all_clients.reverse
          },
          links: {
            total: @with_links,
            data: @all_links
          }
        }
      }

      File.write(@export_path, JSON.pretty_generate(export))
    end

  end
end