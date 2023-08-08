require_relative './base'
module BlackStack
    module Bots
        class Indeed < BlackStack::Bots::SeleniumBot

            def results(url, page=1)
                ret = []
                # launch a chrome browser with selenium
                driver = Selenium::WebDriver.for :chrome
                browser = driver.browser
                # TODO: set a proxy with user and password
                driver.get url
                # get the ul list with class .jobsearch-ResultsList
                ul = driver.find_element(:class=>'jobsearch-ResultsList')
                # scroll to the bottom
                driver.execute_script("window.scrollTo(0, document.body.scrollHeight)")
                # iterate li elements
                i = 0
                ul.find_elements('css', 'li').each { |li|
                    h = {}
                    i += 1
                    links = li.find_elements('css', 'a.jcs-JobTitle')
                    if links.size == 1
                        link = li.find_element('css', 'a.jcs-JobTitle')
                        h[:title] = link.text
                        h[:url] = link.attribute('href')
                    
                        o = li.find_elements('css','span.companyName').first
                        h[:company] = o ? o.text : ''

                        o = li.find_elements('css','div.companyLocation').first
                        h[:location] = o ? o.text : ''
                        
                        o = li.find_elements('css','div.salary-snippet-container').first
                        h[:salary] = o ? o.text : ''
                        
                        o = li.find_elements('css','span.date').first
                        h[:posted] = o ? o.text.gsub("Posted\nPosted", '').strip : ''
                        
                        h[:snippets] = li.find_elements('css','div.job-snippet > ul > li').map { |li| li.text }
                        
                        ret << h
                    end
                }
                # destroy selenium browser
                driver.quit
                # return
                ret
            end # results
        end # Indeed
    end # Bots
end # BlackStack
