class Commands

  class QuitCommand
    def match?(input)
      input == "q"
    end

    def execute
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

    def tweet(message)
      send_tweet(message)
      puts "Tweeted: #{message}"
    end

    def send_tweet(message)
      if message.size <= 140
        @client.update(message)
      else
        puts "Your tweet is too long!"
      end
    end
  end

  class DMCommand
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def my_followers
      screen_names = @client.followers.collect{|f| f.screen_name.downcase}
    end

    def match?(input)
      input == "dm"
    end

    def execute(username, dmmessage)
      if my_followers.include?(username)
        puts "Sending #{username} this direct message: '#{dmmessage}'"
        TweetCommand.new(@client).send_tweet "dm #{username} #{dmmessage}"
      else
        puts "You can't direct message '#{username}' because you aren't following them"
      end
    end
  end

  class FollowersCommand
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def match?(input)
      input == "followers"
    end

    def execute
      screen_names = @client.followers.collect{|f| f.screen_name.downcase}
      puts screen_names
    end
  end

  class SpamFollowers
    attr_reader :client

    dmmessage = DMCommand.new(@client)
    followers = FollowersCommand.new(@client)

    def initialize(client)
      @client = client
    end

    def match?(input)
      input == "spam"
    end

    def execute(message)
      if message.size == 0
        puts "You need to include a message"
      else
        @client.followers.each do |follower|
          dmmessage(follower, message)
        end
      end
    end  
  end

  class NoActionCommand
    def match?(input)
      true
    end

    def execute
    end
  end

end