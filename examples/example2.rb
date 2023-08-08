require_relative '../lib/googlebot'
require_relative './sample.emails.rb' # array of sample list of leads with name and domain.

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
    found = [] # emails found in google
    fname = h[:name].split(' ').first
    lname = h[:name].split(' ').last
    cname = h[:company]
    l.logs "#{i.to_s}. #{fname} #{lname} @ #{cname} (#{h[:email]})... "
    begin
        domains = bot.possible_domains_for_company(cname)
        if domains.size > 0
            domains.each { |domain|
                # array of possible emails
                emails = []
                #emails << "#{fname}@#{domain}"
                #emails << "#{lname}@#{domain}"
                emails << "#{fname}#{lname}@#{domain}"
                emails << "#{fname}.#{lname}@#{domain}"
                emails << "#{fname}_#{lname}@#{domain}"
                emails << "#{fname[0]}#{lname}@#{domain}"
                # iterate array of possible emails
                emails.each { |email|
                    # search for that email
                    search = "\"#{email}\""
                    results = bot.search(search)
                    # find results with the exact email in the description
                    found << email if results.select { |result| result[:description].downcase =~ /\b#{email.downcase}\b/ }
                    # break 
                    break if found.size > 0
                }
                # break 
                break if found.size > 0
            }
            if found.size > 0
                ok += 1
                l.logf("FOUND".green + " (#{found.first})")
            else
                not_found += 1
                l.logf("EMAIL NOT FOUND".yellow)
            end
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