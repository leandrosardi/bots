require 'open-uri'
require 'mechanize'
require 'pry'
require 'simple_cloud_logging'
require 'colorize'


domain = 'oiatlanta.com'

module BlackStack
module Bots
class Scraper
    attr_accessor :domain, :agent, :links
    # auxiliar array of links that I have extracted links from
    attr_accessor :links_processed

    def initialize(init_domain)
        self.domain = init_domain
        self.agent = Mechanize.new
        self.links = []
        self.links_processed = []
    end # def initialize

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
            page = self.agent.get(url)
            # get the self.links to the pages of the website
            aux = page.links.map(&:href)
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
            l.logf "Error: #{e.message.split("\n").first[0..100]})".red # get_links
        end
    end # def get_links_from_url

    def get_links(stop_at=300, l=nil)
        l = BlackStack::DummyLogger.new(nil) if l.nil?
        # working with root url
        url = "https://#{self.domain}/"
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
    end # def get_links

end # class Scraper
end # module Bots
end # module BlackStack

l = BlackStack::LocalLogger.new('scraping.log')
o = BlackStack::Bots::Scraper.new(domain)

l.logs "get_links... "
o.get_links
l.logf "done".green + " (#{o.links.size} links found)" # get_links

