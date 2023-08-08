require 'bots'
require_relative './config' # write the @proxy hash description in this file

l = BlackStack::LocalLogger.new('./google.log')

puts "\n\nEXAMPLE 1".blue
puts "Find top results for the keyword \"ConnectionSphere\".\n".yellow

l.logs 'initialize GoogleBot... '
bot = BlackStack::Bots::Google.new({proxy: @proxy})
l.done

l.logs 'searching... '
results = bot.search('ConnectionSphere')
l.logf "#{results.size.to_s.green} results found"

results.each { |h|
    l.logf "\n\n"
    l.logf "TITLE:\t\t#{h[:title].green}"
    l.logf "URL:\t\t#{h[:url].blue}"
    l.logf "DESCRIPTION:\t#{h[:description].yellow}"
}

exit(0)