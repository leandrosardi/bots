require 'mechanize'
require 'simple_cloud_logging'
require 'colorize'

module BlackStack
    module Bots
        class Google
            attr_accessor :agent # mechanize agent
            attr_accessor :ports # array of ports
            attr_accessor :port_index # index of the port

            def initialize
                # array of numbers from 4000 to 4249
                self.ports = (4000..4249).to_a
                self.port_index = -1
            end # initialize

            def search(query)
                ret = []
                # initialize mechanize agent
                self.agent = Mechanize.new
                # set a proxy with user and password
                self.port_index += 1
                self.port_index = 0 if self.port_index >= self.ports.length
                self.agent.set_proxy('206.83.40.68', self.ports[self.port_index], 'siddique', 'jvg')
                # grab the page
                page = agent.get('http://www.google.com/')
                google_form = page.form('f')
                google_form.q = query
                page = agent.submit(google_form, google_form.buttons.first)

                # iterate divs with class starting with 'g '
                page.search('h3').each do |h3|
                    # get the class of the div
                    title = h3.text.strip
                    # get the link inside the div
                    a = h3.parent.parent.parent
                    href = a['href']
                    descr = a.parent.parent.css('/div').last.text.strip
                    # get the value of the paremter with name param1 from the querystring using URI
                    uri = URI.parse(href)
                    params = CGI.parse(uri.query)
                    url = params['q'].first
                    # add to the list array of results
                    ret << { :title=>title, :url=>url, :description=>descr }
                end
                # destroy mechanize agent
                self.agent.shutdown
                # return
                ret
            end # search
        end # Google

        class GoogleEnrichment < BlackStack::Bots::Google

            # get an array of domains that may be the domain of the company
            def possible_domains_for_company(company_name)
                search = "\"#{company_name}\" home page"
                self.search(search).map { |r| 
                    # get domain from url using URI, and removing www., and downcasing.
                    URI.parse(r[:url]).host.gsub(/^www\./, '').downcase
                }        
            end # possible_domains_for_company

            # find email from fname, lname and cname
            def find_email(fname, lname, cname)
                domains = self.possible_domains_for_company(cname)
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
                            results = self.search(search)
                            # find results with the exact email in the description
                            return email if results.select { |result| result[:description].downcase =~ /\b#{email.downcase}\b/ }
                        }
                    }
                end
                return nil      
            end # find_email

        end # GoogleEnrichment

    end # Bots
end # BlackStack

