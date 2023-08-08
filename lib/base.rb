module BlackStack
    module Bots
        class Bot
            attr_accessor :ip # ip address of proxy
            attr_accessor :user # user of proxy
            attr_accessor :password # password of proxy
            attr_accessor :ports # array of ports
            attr_accessor :port_index # index of the port

            def initialize(h)
                # array of numbers from 4000 to 4249
                unless h[:proxy].nil?
                    self.ip = h[:proxy][:ip]
                    self.user = h[:proxy][:user]
                    self.password = h[:proxy][:password]
                    self.ports = (h[:proxy][:port_from]..h[:proxy][:port_to]).to_a
                end
                self.port_index = -1
            end # initialize

            # return true if the bot is using a proxy
            def proxy?
                !self.ip.nil? 
            end
        end # Bot

        class MechanizeBot < BlackStack::Bots::Bot
            attr_accessor :agent # mechanize agent
        end # MechanizeBot

        class SeleniumBot < BlackStack::Bots::Bot
            attr_accessor :driver # selenium driver
        end # MechanizeBot

    end # Bots
end # BlackStack
