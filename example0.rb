require 'mechanize'

mechanize = Mechanize.new

agent = Mechanize.new
agent.set_proxy('103.144.176.59', 4000, 'siddique', 'jvg')
page = agent.get('http://icanhazip.com/')
puts page.body.to_s

