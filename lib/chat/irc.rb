=begin

= chat/irc.rb

       Jonathan Perkin <jonathan@perkin.org.uk> wrote this file
 
  You can freely distribute/modify it (and are encouraged to do so),
  and you are welcome to buy me a beer if we ever meet and you think
  this stuff is worth it.  Improvements and cleanups always welcome.

  $sketch: irc.rb,v 1.14 2003/02/26 18:24:34 sketch Exp $

=end

require 'chat/common'

require 'chat/irc/command'
require 'chat/irc/event'
require 'chat/irc/message'
require 'chat/irc/numeric'
require 'chat/irc/security'

module IRC

  # IRC client data
  class Client < Chat::Client

    def initialize(host="localhost", port=6667)
      super
      @irccmd = IRC::Command.new
    end

    # 4.1 Connection Registration
    #
    #  The commands described here are used to register a connection with
    #  an IRC server as either a user or a server as well as correctly 
    #  disconnect

    def login(nickname, username, localhost, server, realname)
      send(@irccmd.nick(nickname))
      send(@irccmd.user(username, localhost, server, realname))
    end

    def send(message)
      send_raw(message)
    end

    def getline

      # Get next line from server.
      message = IRC::Message.parse(gets_raw)

      if (message)

        # Pass message off to handlers.
        notify_handlers(message)

        # Even though an observer may have handled this event, still pass the
        # message back to the calling client as it might want to do something
        # with it anyway.
        return message

      end

    end

    def join(channel)
      send(@irccmd.join(channel))
    end

    def quit(message)
      send(@irccmd.quit(message))
    end

  end # class Client

end # module IRC
