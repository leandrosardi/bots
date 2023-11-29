# bots

Service for scraping different sources of information.

Services supported as of today:

- Google
- Indeed

## Installation

```bash
gem install bots
```

## Google

```ruby
require 'bots'

@proxy = {
    ip: '206.83.40.68',
    port_from: 4000,
    port_to: 4249,
    user: '********',
    password: '********',
}

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
```

## Indeed

```ruby
require 'bots'

l = BlackStack::LocalLogger.new('./indeed.log')

puts "\n\nEXAMPLE 1".blue
puts "Find domain of a company using Google Search API.\nCount the number of 'not-found' and 'error' cases.\n".yellow

l.logs 'initialize GoogleBot... '
bot = BlackStack::Bots::Indeed.new(proxy: nil)
l.done

start = 0
search = "https://www.indeed.com/jobs?q=full+time+%2485%2C000&l=Miami%2C+FL&sc=0bf%3Aexrec%28%29%2Ckf%3Ajt%28fulltime%29%3B&radius=100&vjk=469bf011e1ab581f"
while start <= 640
    l.logs "start=#{start}... "

    # build url
    uri = URI.parse(search)
    uri.query = [uri.query, "start=#{start}"].compact.join('&')
    url = uri.to_s
    # scrape results
    ret = bot.results(url)

    # save ret into a json file
    File.open("./indeed1.start-#{start.to_s}.json", 'w') { |f| f.write(ret.to_json) }

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
```