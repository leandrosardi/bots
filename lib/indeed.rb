require_relative './base'
module BlackStack
    module Bots
        class Indeed < BlackStack::Bots::SeleniumBot

            def results(url, page=1)
                ret = []
                # launch a chrome browser with selenium, with proxy
                # refernece: https://www.browserstack.com/guide/set-proxy-in-selenium
                opts = Selenium::WebDriver::Chrome::Options.new
                if self.ip
                    port = self.ports.sample
                    opts.add_argument("--proxy-server=#{self.ip}:#{port}")
                    #opts.add_argument("--headless')
                end
                # start a chrome browser using the proxy configured above
                driver = Selenium::WebDriver.for(:chrome, :options=>opts)
                begin
                    browser = driver.browser

                    # TODO: set a proxy with user and password
                    driver.get url
                    # validate the search has no results
                    # example: https://www.indeed.com/q-$40,000-l-The-Acreage,-FL-jobs.html
                    body = driver.find_element(:tag_name => 'body')
                    return [] if body.text.include?('did not match any jobs')
                    # get the ul list with class .jobsearch-ResultsList
                    ul = driver.find_element(:id=>'mosaic-provider-jobcards').find_element(:css=>'ul')
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
                            o = li.find_elements('css', '[data-testid="company-name"]').first unless o
                            h[:company] = o ? o.text : ''

                            o = li.find_elements('css','div.companyLocation').first
                            o = li.find_elements('css', '[data-testid="text-location"]').first unless o
                            h[:location] = o ? o.text : ''
                            
                            o = li.find_elements('css','div.salary-snippet-container').first
                            h[:salary] = o ? o.text : ''
                            
                            o = li.find_elements('css','span.date').first
                            h[:posted] = o ? o.text.gsub("Posted\nPosted", '').strip : ''
                            
                            h[:snippets] = li.find_elements('css','div.job-snippet > ul > li').map { |li| li.text }
                            
                            ret << h
                        end
                    }
                ensure
                    # destroy selenium browser
                    driver.quit
                end
                # return
                ret
            end # results
        end # Indeed
    end # Bots
end # BlackStack
