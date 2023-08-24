module BlackStack
    module Bots
        class Scraper < BlackStack::Bots::MechanizeBot
            attr_accessor :domain, :links, :timeout
            # auxiliar array of links that I have extracted links from
            attr_accessor :links_processed
        
            def initialize(init_domain, timeout, h)
                super(h)
                self.domain = init_domain
                self.timeout = timeout || 10
                #self.agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                self.links = []
                self.links_processed = []
            end # def initialize

            def get(url)
                # initialize mechanize agent
                self.agent = Mechanize.new
                # set a proxy with user and password
                self.port_index += 1
                self.port_index = 0 if self.port_index >= self.ports.length
                self.agent.set_proxy(self.ip, self.ports[self.port_index], self.user, self.password) if self.proxy?
                self.agent.open_timeout = self.timeout
                self.agent.read_timeout = self.timeout
                # return
                return Timeout::timeout(self.timeout) { self.agent.get(url) }
            end

            def get_links_from_sitemap(l=nil)
                i = 0
                l.logs "Scrape sitemaps... "
                begin
                    # download the robots.txt
                    url = "http://#{domain}/robots.txt"
                    # get the content of robots.txt from url
                    s = Timeout::timeout(self.timeout) { URI.open(url).read }
                    # get the sitemap
                    sitemaps = s.split("\n").select { |line| line =~ /^sitemap:/i }.map { |a| a.downcase.split('sitemap:').last.strip }.uniq
                    sitemaps.each { |b|
                        parser = Timeout::timeout(self.timeout) { SitemapParser.new b }
                        self.links += Timeout::timeout(self.timeout) { parser.to_a }
                        self.links.uniq!
                    }
                    l.logf sitemaps.size == 0 ? 'no sitemap found'.yellow : "#{sitemaps.size} sitemaps found".green # get_links
                rescue => e
                    l.logf "Error: #{e.message.split("\n").first[0..100]})".red # get_links
                end
            end
        
            # internal use only
            def get_links_from_url(url, l=nil)
                l = BlackStack::DummyLogger.new(nil) if l.nil?
                l.logs "get_links (#{url})... "
                begin       
                    aux = []
                    # trim url
                    url = url.strip
                    # get domain of the url using open-uri
                    domain = URI.parse(url).host
                    # visit the main page of the website
                    page = self.get(url)
                    # get the self.links to the pages of the website
                    aux = page.links.map(&:href)
                    # remove non-string elements
                    aux = aux.select { |link| link.is_a?(String) }
                    # remove # from the self.links
                    aux = aux.map { |link| !link.nil? && link.split('#').first }
                    # remove querystring from the self.links
                    aux = aux.map { |link| !link.nil? && link.split('?').first }
                    # remove the self.links that are not http:// or https://
                    aux = aux.select { |link| !link.nil? && link =~ /^https?:\/\// }
                    # remove the self.links that are not from the same domain
                    aux = aux.select { |link| !link.nil? && link =~ /#{domain}/ }
                    # remove nil values
                    aux = aux.compact
                    # remove duplications
                    aux = aux.uniq
                    # filter links who already are in the list
                    a = aux.size
                    aux = aux.select { |link| !self.links.include?(link) }
                    b = aux.size
                    # add new links to self.links
                    self.links += aux
                    l.logf "done".green + " (#{a} links found, #{b} new, #{self.links.size} total)" # get_links
                rescue => e
                    l.logf "Error: #{e.message.split("\n").first[0..100]}".red # get_links
                end
            end # def get_links_from_url
        
            def get_links(stop_at=10, l=nil)
                l = BlackStack::DummyLogger.new(nil) if l.nil?
                # working with root url
                url = "http://#{self.domain}/"
                self.links << url if self.links.select { |link| link == url }.empty?
                # iterate until I have discovered all the links
                while self.links.size != self.links_processed.size && stop_at >= self.links.size
                    # iterate the links who are not in links_processed
                    self.links.select { |link| !self.links_processed.include?(link) }.each { |link|
                        # get the links from the url
                        self.get_links_from_url(link, l)
                        # add the link to the list of processed links
                        self.links_processed << link
                    }
                end # while
                # get links from the sitemap
                self.get_links_from_sitemap(l)
            end # def get_links
        
            def find_keywords(a, stop_at=50, stop_on_first_link_found=false, l=nil)
                pages = []
                l = BlackStack::DummyLogger.new(nil) if l.nil?
                # iterate the links
                j = 0
                self.links.reject { |link| link =~ /\.pdf$/i || link =~ /\.jpg$/i || link =~ /\.jpeg$/i || link =~ /\.gif$/i }.each { |link|
                    j += 1
                    break if j > stop_at
                    l.logs "#{j.to_s}. find_keywords (#{link})... "
                    begin
                        # get the page
                        page = self.get(link)
                        # get page body content in plain text
                        title = page.title
                        s = Timeout::timeout(self.timeout) { page.search('body').text }
                        # add the link to the results of no-keyword
                        hpage = { 'page_url' => link.downcase, 'page_title' => title, 'page_html' => page.body, 'keywords' => [] }
                        pages << hpage
                        # iterate the keywords
                        i = 0
                        match = false
                        a.each { |k|
                            # find the keyword
                            match = ( s =~ /#{Regexp.escape(k)}/i )
                            hpage['keywords'] << k if match
                            # count the number of links with match
                            # break if only 1 link is needed
                            if match 
                                i += 1
                                break if stop_on_first_link_found
                            end # if
                        } # each
                        break if match && stop_on_first_link_found
                        l.logf i == 0 ? 'no keywords found'.yellow : "#{i} keywords found".green # find_keywords
                    rescue => e
                        l.logf "Error: #{e.message.split("\n").first[0..100]}".red # get_links
                    end # begin
                } # each
                # return
                pages
            end
        
        end # class Scraper
    end # module Bots
    end # module BlackStack