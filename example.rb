require 'mechanize'

mechanize = Mechanize.new

q = 'Leandro Sardi "@expandedventure.com"'

=begin
mechanize = Mechanize.new do |agent|
    agent.set_proxy('23.152.226.98', 4000, 'siddique', 'jvg')
end
=end

i = 0
while true
    i += 1
    print "Search #{i}... "

    agent = Mechanize.new
    #agent.set_proxy('23.152.226.98', 4000, 'siddique', 'jvg')

    page = agent.get('http://www.google.com/')
    google_form = page.form('f')
    google_form.q = q
    page = agent.submit(google_form, google_form.buttons.first)

    page.links.each do |link|
        if link.href.to_s =~/url.q/
            str=link.href.to_s
            strList=str.split(%r{=|&}) 
            url=strList[1] 
            puts url
        end 
    end
=begin    
    page.search("//div[contains(@class,'g Ww4FFb vt6azd tF2Cxc')]").each do |span|
        puts span.text
    end
    sleep(1)
    puts
=end
#File.open("google.html", "w") { |f| f.write(body) }
#break
end
