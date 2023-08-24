require 'mechanize'
require 'simple_cloud_logging'
require 'timeout'
require 'colorize'
require_relative './list_of_domains'

l = BlackStack::LocalLogger.new('performance1.log')
n = 30 # timeout in seconds
m = 30 # max number of domains to test
agent = Mechanize.new

i = 0
j = 0
@domains.each { |domain|
    i += 1
    break if i > m
    l.logs "#{i.to_s}. #{domain}... "
    begin
        page = Timeout::timeout(n) { agent.get("http://#{domain}") }
        j += 1 if page
        l.logf page.nil? ? 'not found'.yellow : page.title.to_s.green
    rescue => e
        l.logf "Error: #{e.message}".red
    end
}

l.log "SUMMARY: #{j} of #{i} domains found (#{(j.to_f/i.to_f*100).round(2)}%)"