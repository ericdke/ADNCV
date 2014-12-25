# encoding: utf-8
module ADNCV
  class Data

    attr_reader :count, :leadings, :without_mentions, :mentions_not_directed, :replies, :mentions_not_replies, :with_links, :sources, :all_links, :directed_users, :names, :clients, :mentions

    def initialize
      
    end

    def extract(file)
      decoded = JSON.parse(File.read(file))
      @count = decoded.size

      links = []
      @mentions = 0
      @leadings = 0
      @replies = 0
      @with_links = 0
      mentioned = Hash.new(0) 
      directed = Hash.new(0)
      is_reply = Hash.new(0)
      @clients = Hash.new(0)

      decoded.each do |post|
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
      end

      all_directed = directed.sort_by {|k,v| v}
      all_clients = @clients.sort_by {|k,v| v}
      all_mentioned = mentioned.sort_by {|k,v| v}.uniq
      @all_links = links.uniq.sort
      @names = all_mentioned.map {|k,v| "#{k} (#{v})"}
      @sources = all_clients.map {|k,v| "#{k} (#{v})"}
      @directed_users = all_directed.uniq.map {|k,v| "#{k} (#{v})"}

      @without_mentions = count - @mentions
      @mentions_not_directed = @mentions - @leadings
      @mentions_not_replies = @mentions - @replies

    end

  end
end