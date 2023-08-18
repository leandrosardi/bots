require_relative '../lib/bots'

keywords = ['family owned', 'family-owned']
domains = [
    'companytwofire.com',
    'carolinarecyclingcompany.com',
    'oiatlanta.com',
    'pandhmechanical.com',
    'mtsom.com',
    'carolinapainting.com',
    'gabv.org',
    'brothersaviation.com',
    'hiltonhead360.com',
    'swaimbrown.com',
    'americascuisine.com',
    'dcrotts.com',
    'europeanroadandracing.com',
    'genxsecurity.com',
    'hwprod.com',
    'griffinrad.com',
    'sctechsystem.com',
    'andersongriggs.com',
    'glencofireplaces.com',
    'carolinaplumbing.com',
    'farmhousetack.com',
    'avantitilestone.com',
    'ameliaclaires.com',
    'ocainconstruction.com',
    'bigtcoastalprovisions.com',
    'carolinaqualityice.com',
    'ap-restoration.com',
    'merchneygreenhouses.com',
    'stoddardplastering.com',
    'andersonscchamber.com',
    'spiritoflakemurray.com',
    'acehr.com',
    'triviumperformance.com',
    'charlestonsailingschool.com',
    'columbiaconventioncenter.com',
    'magfinancial.com',
    'southeasternequipment.net',
    'thecharlestonmattress.com',
].uniq

l = BlackStack::LocalLogger.new('scraping1.log')

i = 0
domains.reverse.each { |domain|
    i += 1
    l.logs "#{i}. #{domain}... "

        l2 = nil # l

        o = BlackStack::Bots::Scraper.new(domain, nil)
        #l.logs "get_links... "
        o.get_links(10, l2)
        #l.logf "done".green + " (#{o.links.size} links found)" # get_links

        #l.logs "find_keywords... "
        pages = o.find_keywords(keywords, 50, false, l2)
        a = pages.select { |h| h[:keywords].size > 0 } # pages with matched keyword
        #l.logf "done".green + " (#{a.size} links found)" # find_keywords
    l.logf a.size == 0 ? 'keywords not found'.red : "#{a.size} links found".green # find_keywords
}
