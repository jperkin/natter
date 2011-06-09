#!/usr/bin/env ruby

=begin

= examples/talkerbot.rb

       Jonathan Perkin <jonathan@perkin.org.uk> wrote this file
 
  You can freely distribute/modify it (and are encouraged to do so),
  and you are welcome to buy me a beer if we ever meet and you think
  this stuff is worth it.  Improvements and cleanups always welcome.

  $sketch: talkerbot.rb,v 1.1 2003/03/04 14:15:23 sketch Exp $

=end

# Load the API.
require 'chat/talker'

# Wrap everything inside the Talker module.
module Talker

  # Register a new client, and open a socket to the specified server.
  #bot = Client::new("localhost", 5000)
  bot = Client::new("localhost", 5000)

  # Dump everything we receive into a nice format on stdout.
  Event::Debug.new(bot)

  # Log onto the server.
  bot.login("natterbot", nil)

  # Now just sit there, grabbing input and ignoring most of it :-)
  loop do

    # Grab the input.
    m = bot.getline

    # XXX: Need to work out why we need this and fix properly.
    break if m.nil?

    # This returns true if we received a whisper
    if m.is_a? Message::Whisper

      # Do some lame checking to allow testing of sorts.
      if m.sourcenick == "sketch" && m.params =~ (/^JOIN\s+(.*)$/i)

        # Join specified list
        bot.join($1)

      end

    end

    # Let's add a really lame way of forcing our bot to quit.
    if m.is_a? Message::Whisper

      # Highly secure - we check if it's a private message only to us,
      # and that the first word is `QUIT'.  Grab anything else and use
      # it as the quit reason.
      if m.params =~ (/^QUIT\s+(.*)$/i)

        bot.quit($1)

      end

    end

  end # loop do

end
