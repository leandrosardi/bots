module BlackStack
    module Bots
        class Browser < Watir::Browser
            LOCKFILENAME = '/tmp/blackstack.bots.browser.lock'
            attr_accessor :pids, :lockfile

            def initialize()
                self.lockfile = File.open(LOCKFILENAME, 'w+')

                n = 10 # timeout in seconds

                # wait the lock file /tmp/blackstack.bots.browser.lock
                self.lockfile.flock(File::LOCK_EX)
                begin
                    # get list of PID of all opened chrome browsers, before launching this one 
                    pids_before = `pgrep -f chrome`.split("\n")
# track # of chrome processes
#print "(#{pids_before.size})"
                    # setup driver
                    client = Selenium::WebDriver::Remote::Http::Default.new
                    begin
                        client.read_timeout = n # for newest selenium webdriver version 
                    rescue => e
                        client.timeout = n # deprecated in newest selenium webdriver version
                    end                    
                    options = Selenium::WebDriver::Chrome::Options.new
                    options.add_argument('--headless')

                    # Add this parameter to run Chrome from a root user.
                    # https://stackoverflow.com/questions/50642308/webdriverexception-unknown-error-devtoolsactiveport-file-doesnt-exist-while-t
                    options.add_argument('--no-sandbox') 

                    driver = Selenium::WebDriver.for :chrome, :options => options, http_client: client
                    # create the browser
                    super(driver)
                    # get list of PID of all opened chrome browsers, after launching this one 
                    pids_after = `pgrep -f chrome`.split("\n")
                    # store list of PID regarding this launched browser
                    self.pids = pids_after - pids_before
                rescue => e
                    # unlock the file
                    self.lockfile.flock(File::LOCK_UN)
                    # raise the error
                    raise e
                ensure
                    # unlock the file
                    self.lockfile.flock(File::LOCK_UN)
                end
            end # initialize

            def close
                # kill all pids regarding this browser
                self.pids.each { |pid| `kill -9 #{pid} >/dev/null 2>&1` }
            end # close

            def quit
                # kill all pids regarding this browser
                self.pids.each { |pid| `kill -9 #{pid} >/dev/null 2>&1` }
            end # quit
        end # Browser
    end # Bots
end # BlackStack