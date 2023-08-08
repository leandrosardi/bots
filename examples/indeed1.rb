require_relative '../lib/indeedbot'

l = BlackStack::LocalLogger.new('./indeed1.log')

puts "\n\nEXAMPLE 1".blue
puts "Find domain of a company using Google Search API.\nCount the number of 'not-found' and 'error' cases.\n".yellow

l.logs 'initialize GoogleBot... '
bot = BlackStack::Bots::Indeed.new
l.done

start = 0
while start <= 640
    l.logs "start=#{start}... "

    url = "https://www.indeed.com/jobs?q=full+time+%2485%2C000&l=Miami%2C+FL&sc=0bf%3Aexrec%28%29%2Ckf%3Ajt%28fulltime%29%3B&radius=100&vjk=469bf011e1ab581f&start=#{start}"
    ret = bot.results(url)

    # save ret into a json file
    #File.open("./indeed1.start-#{start.to_s}.json", 'w') { |f| f.write(ret.to_json) }
    File.open("./indeed1.all.json", 'a+b') { |f| f.write(ret.to_json) }

    # save into a CSV file
    CSV.open("./indeed1.all.csv", 'a+b') { |csv|
        csv << ['title', 'url', 'company', 'location', 'salary', 'posted', 'snippets']
        ret.each { |h|
            csv << [h[:title], h[:url], h[:company], h[:location], h[:salary], h[:posted], h[:snippets].join(' / ')]
        }        
    }

    # increase start
    start += 10

    l.done
end