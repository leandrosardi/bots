# references:
# - https://stackoverflow.com/questions/57408369/how-can-i-stop-page-loading-and-close-browser-in-ruby-watir-when-i-takes-to-much

require 'selenium-webdriver'
require 'watir'
require 'simple_cloud_logging'
require 'timeout'
require 'colorize'
require_relative './list_of_domains'

l = BlackStack::LocalLogger.new('performance2.log')
n = 5 # timeout in seconds

=begin
# --------------------------

client = Selenium::WebDriver::Remote::Http::Default.new
begin
    client.read_timeout = n # for newest selenium webdriver version 
rescue => e
    client.timeout = n # deprecated in newest selenium webdriver version
end

driver = Selenium::WebDriver.for :chrome #, :switches => switches

bridge = driver.instance_variable_get(:@bridge)
service = bridge.instance_variable_get(:@service)
process = service.instance_variable_get(:@process)
driver.manage.window().maximize()
browser = Watir::Browser.new(driver)
binding.pry
sleep(999999999)

begin
    l.logs "goto... "
    browser.goto "https://www.google.com"
    l.logf browser.title.to_s.green


rescue Net::ReadTimeout => e
    l.logf "Timeout Error: #{e.message}".red
    #browser.close rescue ''
rescue => e
    l.logf "Error: #{e.message}".red
end

sleep(99999999)

# --------------------------
=end

m = 1 #30 # max number of domains to test

client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = n # seconds
browser = Watir::Browser.new :chrome, http_client: client

# get pid of the current process
pid = Process.pid

# get pid of the children processes who are runnign a chrome browser
pids = `pgrep -P #{pid}`.split("\n")

pids2 = `pgrep -P #{pids.first}`.split("\n")

# kill the children processes
pids.each { |id| 
    `kill -9 -f #{pid}` 
}

binding.pry

i = 0
j = 0
@domains.each { |domain|
    i += 1
    break if i > m
    l.logs "#{i.to_s}. #{domain}... "
    begin
        browser.goto "http://#{domain}"
        j += 1
        l.logf browser.title.to_s.green
    rescue Net::ReadTimeout => e
        l.logf "Timeout Error: #{e.message}".red
binding.pry
        browser.execute_script('window.stop();')
    rescue => e
        l.logf "Error: #{e.message}".red
    rescue
        browser.close
    end
}

l.log "SUMMARY: #{j} of #{i} domains found (#{(j.to_f/i.to_f*100).round(2)}%)"