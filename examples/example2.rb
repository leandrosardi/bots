require_relative '../lib/googlebot'

require_relative './sample.emails.rb' # array of sample list of leads with an VERIFIED email provided by LeadHype - Hit rate is close 100% here!
#require_relative './sample.leads.rb' # array of sample list of leads LeadHype with or without verified email

l = BlackStack::LocalLogger.new('./example2.log')

puts "\n\nEXAMPLE 2".blue
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
    fname = h[:name].split(' ').first
    lname = h[:name].split(' ').last
    cname = h[:company]
    l.logs "#{i.to_s}. #{fname} #{lname} @ #{cname} (#{h[:email]})... "
    begin
        email = bot.find_email(fname, lname, cname)
        if email
            ok += 1
            l.logf("FOUND".green + " (#{email})")
        else
            not_found += 1
            l.logf("NOT FOUND".yellow)
        end
    # catch if the user pressed CTRL+C
    rescue Interrupt => e
        l.logf("INTERRUPTED".red)
        break
    rescue Exception => e
        error += 1
        l.logf("ERROR".red + " (#{e.to_console})")
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