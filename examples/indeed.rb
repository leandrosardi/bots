require_relative '../lib/bots'

puts "\n\nEXAMPLE 1".blue
puts "Find domain of a company using Google Search API.\nCount the number of 'not-found' and 'error' cases.\n".yellow

a = [
    #{ :tag => 'Jacksonville', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Jacksonville%2C+FL&radius=25&vjk=4d50a7da37ac13e8' },
    { :tag => 'Miami', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Miami%2C+FL&vjk=47ad6f146bdb38b6' },
    { :tag => 'Tampa', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Tampa%2C+FL&vjk=755069ad4d1b55f3' },
    { :tag => 'Orlando', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Orlando%2C+FL&vjk=be54d60a945f387a' },
    { :tag => 'St. Petersburg', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=St.+Petersburg%2C+FL&vjk=a2798dfd6b44cbca' },
    { :tag => 'Hialeah', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Hialeah%2C+FL&vjk=1f6688f53ad7f71e' },
    { :tag => 'Port St. Lucie', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Port+St.+Lucie&vjk=1ebd75596f27b357' },
    { :tag => 'Cape Coral', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Cape+Coral%2C+FL&vjk=389dea8e44eef9c2' },
    { :tag => 'Tallahassee', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Tallahassee%2C+FL&vjk=ef96454e754e9ae0' },
    { :tag => 'Fort Lauderdale', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Fort+Lauderdale%2C+FL&vjk=34f20be641c0fecb' },
]

a.each { |h|
    tag = h[:tag]
    search = h[:search]

    l = BlackStack::LocalLogger.new("./indeed.#{tag}.log")

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
}
