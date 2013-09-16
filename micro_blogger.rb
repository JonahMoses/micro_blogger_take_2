require 'jumpstart_auth'
require 'pry'
require 'bitly'
require 'klout'

Bitly.use_api_version_3
Klout.api_key = 'xu9ztgnacmjx3bu82warbr3h'


class MicroBlogger
  attr_reader :client
  attr_accessor :screen_names

  def initialize
    @client  = JumpstartAuth.twitter
    @friends = @client.friends
    @screen_names = @client.followers.collect{|f| f.screen_name.downcase}
  end

  # def shorten(original_url)
  #   bitly     = Bitly.new('hungryacademy','R_430e9f62250186d2612cca76eee2dbc6')
  #   short_url = bitly.shorten(original_url).short_url
  #   return short_url
  # end

  # def klout_score
  #   my_followers.each do |screen_name|
  #     puts screen_name
  #     begin
  #       identity    = Klout::Identity.find_by_screen_name(screen_name)
  #       user        = Klout::User.new(identity.id)
  #       klout_score = user.score.score
  #     rescue
  #       puts "Coulnd't find Klout score #{screen_name}"
  #     end
  #   end
  # end

  # def sorted_friends
  #   sorted_friends = @friends.sort_by{ |friend| friend.screen_name.downcase}
  # end

  # def latest_tweets
  #   sorted_friends.each do |friend|
  #     fancy_time = friend.status.created_at.strftime("%A, %b %d")
  #     puts "#{friend.name} #{friend.screen_name} said: #{friend.status.text} on #{fancy_time} \n \n"
  #   end
  # end

  def run
    puts "Welcome to the gSchool Twitter Client"
      while @command != "quit"
        printf "Enter Command: "
        input         = gets.chomp
        execute_command(input)
    end
  end

  def commands
    quit      = QuitCommand.new
    tweet     = TweetCommand.new(@client)
    dmcommand = DMCommand.new(@client,@screen_names)
    followers = FollowersCommand.new(@client,@screen_names)
    spam      = SpamFollowers.new(@client,@screen_names)
    no_action = NoActionCommand.new

    [ quit, tweet, dmcommand, followers, spam, no_action ] #elt, s, turl, klout, 
  end

  def execute_command(input)
    parts     = input.split(" ")
    @command  = parts[0]
    @username = parts[1]
    message   = parts[1..-1].join(" ")

    command_for_input(@command).execute(parts)
  end

  def command_for_input(command_input)
    commands.find {|command| command.match?(command_input) }
  end

  class QuitCommand
    def match?(command)
      command == "quit"
    end

    def execute(message)
      puts "Goodbye!"
    end
  end

  class TweetCommand
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def match?(input)
      input == "t"
    end

    def execute(message)
      tweet(message)
    end

    def tweet(parts)
      send_tweet(parts[1..-1].join(" "))
      puts "Tweeted: #{parts[1..-1].join(" ")}"
    end

    def send_tweet(parts)
      if parts[1..-1].size <= 140
        @client.update(parts[1..-1])
      else
        puts "Your tweet is too long!"
      end
    end
  end

  class DMCommand
    attr_reader :client

    def initialize(client,screen_names)
      @client       = client
      @screen_names = @client.followers.collect{|f| f.screen_name.downcase}
    end

    def match?(command)
      command == "dm"
    end

    def execute(parts)
      if @screen_names.include?(parts[1])
        puts "Sending #{parts[1]} this direct message: '#{parts[2..-1].join(" ")}'"
        TweetCommand.new(@client).send_tweet "dm #{parts[1]} #{parts[2..-1].join(" ")}"
      else
        puts "You can't direct message '#{parts[1]}' because you aren't following them"
      end
    end
  end

  class FollowersCommand
    attr_reader :client
    attr_reader :screen_names

    def initialize(client, screen_names)
      @client = client
      @screen_names = screen_names
    end

    def match?(input)
      input == "followers"
    end

    def execute(input)
      puts @screen_names
    end
  end

  class SpamFollowers
    attr_reader :client
    attr_reader :screen_names

    def initialize(client,screen_names)
      @client = client
      @screen_names = @client.followers.collect{|f| f.screen_name.downcase}
    end

    def match?(input)
      input == "spam"
    end

    def execute(screen_name,message)
      @screen_names.each do |follower|
        DMCommand.new(@client).execute(follower, message)
      end
    end  
  end

  class NoActionCommand
    def match?(command)
      true
    end

    def execute(parts)
      puts "uhhh crap...you broke me"
    end
  end
end

blogger = MicroBlogger.new
blogger.run