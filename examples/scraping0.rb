require_relative '../lib/bots'

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

l = BlackStack::LocalLogger.new('scraping0.log')

timeout = 30 # seconds
i = 0
domains.reverse.each { |domain|
    i += 1
    l.logs "#{i}. #{domain}... "
    o = BlackStack::Bots::Scraper.new(domain, timeout, nil)
    o.get_links(10, nil)
    l.logf o.links.size == 0 ? 'no links'.yellow : "links: #{o.links.size.to_s.green}"
}
