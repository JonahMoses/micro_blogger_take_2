def commands
    quit      = QuitCommand.new
    tweet     = TweetCommand.new(@client)
    dmcommand = DMCommand.new(@client,@screen_names)
    followers = FollowersCommand.new(@client,@screen_names)
    spam      = SpamFollowers.new(@client,@screen_names)
    no_action = NoActionCommand.new

    [ quit, tweet, dmcommand, followers, spam, no_action ] #elt, s, turl, klout, 
 

      # if quit.match?(command) 
      #   quit.execute
      # elsif tweet.match?(command)
      #   tweet.execute(message)
      # elsif dmcommand.match?(command)
      #   dmmessage = parts[2..-1].join(" ")
      #   dmcommand.execute(username, dmmessage)
      # elsif followers.match?(command)
      #   followers.execute
      # elsif spam.match?(command)      
      #     spam.execute(message)

      # elsif command == 'elt'       
      #   latest_tweets
      # elsif command == 's'         
      #   shorten(message)
      # elsif command == 'turl'      
      #   tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
      # elsif command == 'klout'     
      #   klout_score
      # else 
      #   puts "Sorry, I don't understand the '#{command}' command"
      # end
      # return command
  end