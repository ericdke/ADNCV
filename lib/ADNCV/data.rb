# encoding: utf-8
module ADNCV
  class Data

    attr_reader :filename, :count, :leadings, :without_mentions, :mentions_not_directed, :replies, :mentions_not_replies, :with_links, :sources, :all_links, :directed_users, :names, :clients, :mentions, :all_clients, :all_mentioned, :reposts, :stars
    attr_accessor :export_path

    def initialize
      
    end

    def extract(file)
      @filename = file
      decoded = JSON.parse(File.read(file))
      @count = decoded.size

      links = []
      @mentions = 0
      @leadings = 0
      @replies = 0
      @with_links = 0
      @reposts = 0
      @stars = 0
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
        unless post["num_reposts"].nil?
          @reposts += post["num_reposts"]
        end
        unless post["num_stars"].nil?
          @stars += post["num_stars"]
        end
      end

      all_directed = directed.sort_by {|k,v| v}
      @all_clients = @clients.sort_by {|k,v| v}
      @all_mentioned = mentioned.sort_by {|k,v| v}.uniq
      @all_links = links.uniq.sort
      @names = @all_mentioned.map {|k,v| "#{k} (#{v})"}
      @sources = @all_clients.map {|k,v| "#{k} (#{v})"}
      @directed_users = all_directed.uniq.map {|k,v| "#{k} (#{v})"}

      @without_mentions = count - @mentions
      @mentions_not_directed = @mentions - @leadings
      @mentions_not_replies = @mentions - @replies

    end

    def export
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
              with_links: @with_links
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

      @export_path = "#{Dir.home}/adncv_export.json"
      File.write(@export_path, export.to_json)
    end

  end
end