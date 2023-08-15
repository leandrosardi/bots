require_relative '../lib/bots'

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



l = BlackStack::LocalLogger.new('scraping.log')

i = 0
#domains.select { |s| s=='columbiafireandsafety.com' }.each { |domain|
domains.reverse.each { |domain|
    i += 1
    l.logs "#{i}. #{domain}... "

        o = BlackStack::Bots::Scraper.new(domain)
        #l.logs "get_links... "
        o.get_links(10) #, l)
        #o.links = []
        #o.links << 'https://oiatlanta.com/products/grand-rapids-chair/'
        #o.links << 'https://oiatlanta.com/give-an-experience-this-year/'
        #l.logf "done".green + " (#{o.links.size} links found)" # get_links

        #l.logs "find_keywords... "
        a = o.find_keywords(keywords) #, 50, l)
        #l.logf "done".green + " (#{a.size} links found)" # find_keywords

    l.logf a.size == 0 ? 'keywords not found'.red : "#{a.size} links found".green # find_keywords
}
