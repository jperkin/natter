#!/usr/bin/env ruby

=begin

= examples/ircbot.rb

       Jonathan Perkin <jonathan@perkin.org.uk> wrote this file
 
  You can freely distribute/modify it (and are encouraged to do so),
  and you are welcome to buy me a beer if we ever meet and you think
  this stuff is worth it.  Improvements and cleanups always welcome.

  $sketch: ircbot.rb,v 1.2 2003/03/03 18:13:44 sketch Exp $

=end

# Load the API.
require 'chat/irc'

# Wrap everything inside the IRC module.
module IRC

  # Register a new client, and open a socket to the specified server.
  bot = Client::new("irc.server.net", 6667)

  # This registers with the default PING handler, which keeps us on IRC.
  # We still get the full PING message if we want to look at it, but we
  # don't have to do anything with it.
  Event::Ping.new(bot)

  # Dump everything we receive into a nice format on stdout.
  Event::Debug.new(bot)

  # Log onto the server.
  bot.login("natterbot", "natter", "8", "*", "I am a bot, kill me!")

  # Now just sit there, grabbing input and ignoring most of it :-)
  loop do

    # Grab the input.
    m = bot.getline

    # This returns true if we received an IRC command (numeric).
    if m.is_a? Message::Numeric

      # Use the unique identifiers RPL_ENDOFMOTD or ERR_NOMOTD as a
      # trigger for joining the first channel.
      if m.command == RPL_ENDOFMOTD || m.command == ERR_NOMOTD

        # Bet we're the first ones here..  :-)
        bot.join("#nattertest")

      end

    end

    # Let's add a really lame way of forcing our bot to quit.
    if m.is_a? Message::Private

      # Highly secure - we check if it's a private message only to us,
      # and that the first word is `QUIT'.  Grab anything else and use
      # it as the quit reason.
      if m.dest == "natterbot" && m.params =~ (/^QUIT\s+(.*)$/i)

        bot.quit($1)

        # Close the socket..
        bot.shutdown

        # ..and end the program.
        break

      end

    end

  end # loop do

end
