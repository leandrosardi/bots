require 'bots'

l = BlackStack::LocalLogger.new('./indeed1.log')

puts "\n\nEXAMPLE 1".blue
puts "Find domain of a company using Google Search API.\nCount the number of 'not-found' and 'error' cases.\n".yellow

l.logs 'initialize GoogleBot... '
bot = BlackStack::Bots::Indeed.new(proxy: nil)
l.done

output_filename = 'indeed2'
start = 0
search = "https://www.indeed.com/q-full-time-$85,000-l-Jacksonville,-FL-jobs.html?vjk=c344d10b0d9d6b38"
while start <= 640
    l.logs "start=#{start}... "

    url = "#{search}&start=#{start}"
    ret = bot.results(url)

    # save ret into a json file
    File.open("./#{output_filename}.start-#{start.to_s}.json", 'w') { |f| f.write(ret.to_json) }

    # save into a CSV file
    CSV.open("./#{output_filename}.all.csv", 'a+b') { |csv|
        csv << ['title', 'url', 'company', 'location', 'salary', 'posted', 'snippets']
        ret.each { |h|
            csv << [h[:title], h[:url], h[:company], h[:location], h[:salary], h[:posted], h[:snippets].join(' / ')]
        }        
    }

    # increase start
    start += 10

    l.done
end