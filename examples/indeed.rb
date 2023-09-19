require_relative '../lib/bots'

tag = 'Jacksonville'

l = BlackStack::LocalLogger.new("./indeed.#{tag}.log")

puts "\n\nEXAMPLE 1".blue
puts "Find domain of a company using Google Search API.\nCount the number of 'not-found' and 'error' cases.\n".yellow

l.logs 'initialize GoogleBot... '
bot = BlackStack::Bots::Indeed.new(
    ip: '192.151.150.90',
    user: nil,
    password: nil,
    port_from: 19010,
    port_to: 19010
)
l.done

output_filename = 'indeed2'
start = 0
search = "https://www.indeed.com/jobs?q=%2435%2C000&l=Jacksonville%2C+FL&radius=25&vjk=4d50a7da37ac13e8"
while start <= 640
begin
    l.logs "start=#{start.to_s.blue}... "

    url = "#{search}&start=#{start}"
    ret = bot.results(url)

    # save ret into a json file
    #File.open("./#{output_filename}.start-#{start.to_s}.json", 'w') { |f| f.write(ret.to_json) }

    # save into a CSV file
    CSV.open("./#{output_filename}.#{tag}.csv", 'a+b') { |csv|
        csv << ['title', 'url', 'company', 'location', 'salary', 'posted', 'snippets']
        ret.each { |h|
            csv << [h[:title], h[:url], h[:company], h[:location], h[:salary], h[:posted], h[:snippets].join(' / ')]
        }        
    }

    # increase start
    start += 10

    l.logf 'done'.green
# catch when user press CTRL+C
rescue Interrupt => e
    l.logf "Process canceled by user".yellow
    exit(0)
rescue Exception => e
    l.logf "ERROR: #{e.message}".red
end
end