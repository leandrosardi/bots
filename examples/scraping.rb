require 'open-uri'
require 'mechanize'
require 'pry'
require 'simple_cloud_logging'
require 'colorize'
require 'sitemap-parser'

keywords = ['family owned', 'family-owned']
domains = [
'companytwofire.com',
'carolinarecyclingcompany.com',
'oiatlanta.com',
'pandhmechanical.com',
'mtsom.com',
'avisbudgetgroup.com',
'apextoolgroup.com',
'carolinapainting.com',
'coastalconstruction.com',
'gabv.org',
'hargray.com',
'hargray.com',
'highlandbrokerage.com',
'brothersaviation.com',
'hiltonhead360.com',
'guardianlife.com',
'swaimbrown.com',
'americascuisine.com',
'cellairis.com',
'charlestonheatingandair.com',
'columbiafireandsafety.com',
'advisorsinsuranceagency.com',
'milliken.com',
'freedomboatclub.com',
'genesys.com',
'southstatebank.com',
'southstatebank.com',
'crowe.com',
'dcrotts.com',
'efwnow.com',
'europeanroadandracing.com',
'genxsecurity.com',
'gru.edu',
'scjohnson.com',
'hwprod.com',
'griffinrad.com',
'sctechsystem.com',
'southstatebank.com',
'southstatebank.com',
'andersonuniversity.edu',
'andersongriggs.com',
'glencofireplaces.com',
'carolinaplumbing.com',
'utulsa.edu',
'darlingtonraceway.com',
'bitt.com',
'moodys.com',
'southstatebank.com',
'farmhousetack.com',
'eastwoodhomes.com',
'instantimprints.com',
'riversedgenursery.com',
'tosibox.com',
'milerproperties.com',
'premierhealth.com',
'avantitilestone.com',
'coxanddinkins.com',
'ecpi.edu',
'ameliaclaires.com',
'hardwarespecialty.com',
'huronconsultinggroup.com',
'macaronikid.com',
'ocainconstruction.com',
'greenwoodrealty.com',
'erskine.edu',
'mbakerintl.com',
'southstatebank.com',
'bigtcoastalprovisions.com',
'carolinaqualityice.com',
'carolinahomesc.com',
'ap-restoration.com',
'hometeam.com',
'irontribefitness.com',
'merchneygreenhouses.com',
'palmettomoononline.com',
'seerinteractive.com',
'stoddardplastering.com',
'hargray.com',
'wearevp.com',
'andersonscchamber.com',
'spiritoflakemurray.com',
'acehr.com',
'triviumperformance.com',
'southstatebank.com',
'charlestonsailingschool.com',
'columbiaconventioncenter.com',
'islandrealty.com',
'magfinancial.com',
'michelin.com',
'milliken.com',
'amphoraconsulting.com',
'southeasternequipment.net',
'synovus.com',
'thecharlestonmattress.com',
].uniq

module BlackStack
module Bots
class Scraper
    attr_accessor :domain, :agent, :links
    # auxiliar array of links that I have extracted links from
    attr_accessor :links_processed

    def initialize(init_domain)
        self.domain = init_domain
        self.agent = Mechanize.new
        #self.agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        self.links = []
        self.links_processed = []
    end # def initialize

    def get_links_from_sitemap(l=nil)
        i = 0
        l.logs "Scrape sitemaps... "
        begin
            # download the robots.txt
            url = "https://#{domain}/robots.txt"
            # get the content of robots.txt from url
            s = URI.open(url).read
            # get the sitemap
            sitemaps = s.split("\n").select { |line| line =~ /^sitemap:/i }.map { |a| a.downcase.split('sitemap:').last.strip }.uniq
            sitemaps.each { |b|
                parser = sitemap = SitemapParser.new b
                self.links += parser.to_a
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

    def get_links(stop_at=10, l=nil)
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
        # get links from the sitemap
        self.get_links_from_sitemap(l)
    end # def get_links

    def find_keywords(a, l=nil)
        ret = []
        l = BlackStack::DummyLogger.new(nil) if l.nil?
        # iterate the links
        self.links.each { |link|
            l.logs "find_keywords (#{link})... "
            begin
                # get the page
                page = self.agent.get(link)
                # get page body content in plain text
                s = Nokogiri::HTML(page.body).text
                # iterate the keywords
                i = 0
                a.each { |k|
                    # find the keyword
                    if s =~ /#{Regexp.escape(k)}/i
                        i += 1
                        ret << link if ret.select { |link| link == link }.empty?
                        break
                    end # if
                } # each
                l.logf i == 0 ? 'no keywords found'.yellow : "#{i} keywords found".green # find_keywords
            rescue => e
                l.logf "Error: #{e.message.split("\n").first[0..100]})".red # get_links
            end # begin
        } # each
        # return
        ret
    end

end # class Scraper
end # module Bots
end # module BlackStack

l = BlackStack::LocalLogger.new('scraping.log')

i = 0
#domains.select { |s| s=='avisbudgetgroup.com' }.each { |domain|
domains.each { |domain|
    i += 1
    l.logs "#{i}. #{domain}... "

        o = BlackStack::Bots::Scraper.new(domain)
        l.logs "get_links... "
        o.get_links(10) #, l)
        #o.links = []
        #o.links << 'https://oiatlanta.com/products/grand-rapids-chair/'
        #o.links << 'https://oiatlanta.com/give-an-experience-this-year/'
        l.logf "done".green + " (#{o.links.size} links found)" # get_links

        l.logs "find_keywords... "
        a = o.find_keywords(keywords) #, l)
        l.logf "done".green + " (#{a.size} links found)" # find_keywords

    l.logf a.size == 0 ? 'keywords not found'.red : "#{a.size} links found".green # find_keywords
}
