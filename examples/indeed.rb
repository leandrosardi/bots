require_relative '../lib/bots'

puts "\n\nEXAMPLE 1".blue
puts "Find domain of a company using Google Search API.\nCount the number of 'not-found' and 'error' cases.\n".yellow

a = [
    # FL
    #{ :tag => 'Jacksonville', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Jacksonville%2C+FL&radius=25&vjk=4d50a7da37ac13e8' },
    #{ :tag => 'Miami', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Miami%2C+FL&vjk=47ad6f146bdb38b6' },
    #{ :tag => 'Tampa', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Tampa%2C+FL&vjk=755069ad4d1b55f3' },
    #{ :tag => 'Orlando', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Orlando%2C+FL&vjk=be54d60a945f387a' },
    #{ :tag => 'St. Petersburg', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=St.+Petersburg%2C+FL&vjk=a2798dfd6b44cbca' },
    #{ :tag => 'Hialeah', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Hialeah%2C+FL&vjk=1f6688f53ad7f71e' },
    #{ :tag => 'Port St. Lucie', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Port+St.+Lucie&vjk=1ebd75596f27b357' },
    #{ :tag => 'Cape Coral', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Cape+Coral%2C+FL&vjk=389dea8e44eef9c2' },
    #{ :tag => 'Tallahassee', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Tallahassee%2C+FL&vjk=ef96454e754e9ae0' },
    #{ :tag => 'Fort Lauderdale', :search => 'https://www.indeed.com/jobs?q=%2435%2C000&l=Fort+Lauderdale%2C+FL&vjk=34f20be641c0fecb' },

    # NC
    #{:tag=>'Raleigh', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Raleigh%2C+NC&vjk=e2eb76a72f7ae745'},
    #{:tag=>'Greensboro', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Greensboro%2C+NC&vjk=268f60d9b55ab42c'},
    #{:tag=>'Durham', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Durham%2C+NC&vjk=e2eb76a72f7ae745'},
    #{:tag=>'Winston-Salem', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Winston-Salem%2C+NC&vjk=0ff9e32dfd6d55a0'},
    #{:tag=>'Fayetteville', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Fayetteville%2C+NC&vjk=0da7b3873e365697'},
    #{:tag=>'Cary', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Cary%2C+NC&vjk=e2eb76a72f7ae745'},
    #{:tag=>'Wilmington', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Wilmington%2C+NC&vjk=ae26211233bf37ce'},
    #{:tag=>'High Point', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=High+Point%2C+NC&vjk=f435ca2dfa61bd8b'},
    #{:tag=>'Concord', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Concord%2C+NC&vjk=1134ea46fe739b21'},

    # SC
    #{:tag=>'sc.Charleston', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Charleston%2C+SC&vjk=d66cee732eb0d03b'},
    #{:tag=>'sc.Columbia', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Columbia%2C+SC&vjk=341d0ef4ba7eb4ed'},
    #{:tag=>'sc.North Charleston', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=North+Charleston%2C+SC&vjk=d66cee732eb0d03b'},
    #{:tag=>'sc.Mount Pleasant', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Mount+Pleasant%2C+SC&vjk=95f35aa53862fb07'},
    #{:tag=>'sc.Rock Hill', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Rock+Hill%2C+SC&vjk=a59e5eed4fce1928'},
    #{:tag=>'sc.Greenville', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Greenville%2C+SC&vjk=17742f8f24418e5f'},
    #{:tag=>'sc.Summerville', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Summerville%2C+SC&vjk=d66cee732eb0d03b'},
    #{:tag=>'sc.Goose Creek', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Goose+Creek%2C+SC&vjk=c68395c312b2aafc'},
    #{:tag=>'sc.Hilton Head Island', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Hilton+Head+Island%2C+SC&vjk=101fdecf4ac4d0fe'},
    #{:tag=>'sc.Sumter', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Sumter%2C+SC&vjk=d8a7a955a1b11407'},

    # Oregon
    #{:tag=>'or.Portland', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Portland%2C+OR&vjk=92eecfff4d8b6dac'},
    #{:tag=>'or.Salem', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Salem%2C+OR&vjk=145faf9f45ceb59d'},
    #{:tag=>'or.Eugene', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Eugene%2C+OR&vjk=45992eaa55cbced6'},
    #{:tag=>'or.Hillsboro', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Hillsboro%2C+OR&vjk=92eecfff4d8b6dac'},
    #{:tag=>'or.Gresham', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Gresham%2C+OR&vjk=92eecfff4d8b6dac'},
    #{:tag=>'or.Bend', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Bend%2C+OR&vjk=ad4a0ca994ec5d09'},
    #{:tag=>'or.Beaverton', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Beaverton%2C+OR&vjk=b016c30990b31345'},
    #{:tag=>'or.Medford', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Medford%2C+OR&vjk=ab583941b3e6bd6e'},
    #{:tag=>'or.Springfield', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Springfield%2C+OR&vjk=25e3e9972900a46b'},
    #{:tag=>'or.Corvallis', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Corvallis%2C+OR&vjk=c4639ddc41903ad4'},

    # Nevada
    #{:tag=>'nv.Las Vegas', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Las+Vegas%2C+NV&vjk=f3cecd89f25b655a'},
    #{:tag=>'nv.Henderson', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Henderson%2C+NV&vjk=f3cecd89f25b655a'},
    #{:tag=>'nv.Reno', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Reno%2C+NV&vjk=223a3ab1b6555870'},
    #{:tag=>'nv.North Las Vegas', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=North+Las+Vegas%2C+NV&vjk=f3cecd89f25b655a'},
    {:tag=>'nv.Paradise', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Paradise%2C+NV&vjk=f3cecd89f25b655a'},
    {:tag=>'nv.Spring Valley', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Spring+Valley%2C+NV&vjk=f3cecd89f25b655a'},
    {:tag=>'nv.Sunrise Manor', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Sunrise+Manor%2C+NV&vjk=9224f02e2408cdd2'},
    {:tag=>'nv.Enterprise', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Enterprise%2C+NV&vjk=9224f02e2408cdd2'},
    {:tag=>'nv.Sparks', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Sparks%2C+NV&vjk=703532c32942c2be'},
    {:tag=>'nv.Carson City', :search=>'https://www.indeed.com/jobs?q=%2435%2C000&l=Carson+City%2C+NV&vjk=cbb53a875f26e068'},
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
