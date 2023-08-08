require_relative '../lib/googlebot'
require_relative './sample.emails.rb' # array of sample list of leads with name and domain.

l = BlackStack::LocalLogger.new('./example1.log')

puts "\n\nEXAMPLE 1".blue
puts "Find domain of a company using Google Search API.\nCount the number of 'not-found' and 'error' cases.\n".yellow

l.logs "# of leads... "
l.logf @leads.size.to_s.green

l.logs 'initialize GoogleBot... '
bot = BlackStack::Bots::GoogleEnrichment.new
l.done

i = 0 # rows processed
ok = 0 # number of domains found
error = 0 # number of errors
not_found = 0 # number of domains not found
@leads.each { |h|
    i += 1
    l.logs "#{i.to_s}. #{h[:company]} (#{h[:domain]})... "
    begin
        domains = bot.possible_domains_for_company(h[:company])
        domains.select! { |d| d.downcase == h[:domain].downcase }
        if domains.size > 0
            ok += 1
            l.logf("OK".green + " (#{domains.first})")
        else
            not_found += 1
            l.logf("DOMAIN NOT FOUND".yellow)
        end
    # catch if the user pressed CTRL+C
    rescue Interrupt => e
        l.logf("INTERRUPTED".red)
        break
    rescue Exception => e
        error += 1
        l.logf("ERROR".red + " (#{e.message})")
    end
break if i > 30
}

l.log "DONE".green
puts "\n\n"
l.log "RESULTS:\t\t#{i.to_s.blue}"
l.log "OK:\t\t#{ok.to_s.green}"
l.log "ERROR:\t\t#{error.to_s.red}"
l.log "NOT FOUND:\t\t#{not_found.to_s.yellow}"
exit(0)