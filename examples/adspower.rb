require 'uri'
require 'net/http'
require 'json'
require 'pry'
require 'blackstack-core'

# reference: https://localapi-doc-en.adspower.com/
# reference: https://localapi-doc-en.adspower.com/docs/Rdw7Iu
@key = 'b729c93ea23eea308bdeb07c8d2a49a8'
@url = 'http://127.0.0.1:50325'

# send an GET request to "#{url}/status"
# and return the response body.
# 
# reference: https://localapi-doc-en.adspower.com/docs/6DSiws
# 
def status
    uri = URI.parse("#{@url}/status")
    res = Net::HTTP.get(uri)
    # show respose body
    puts JSON.parse(res)['msg']
end

# send a post request to "#{url}/api/v1/user/create"
# and return the response body.
#
# return id of the created user
# 
# reference: https://localapi-doc-en.adspower.com/docs/6DSiws
# reference: https://localapi-doc-en.adspower.com/docs/Lb8pOg
# reference: https://localapi-doc-en.adspower.com/docs/Awy6Dg
# 
def create
    uri = URI.parse("#{@url}/api/v1/user/create")
    res = Net::HTTP.post_form(uri, {
        #'api_key' => @key,
        'group_id' => '0',
        'proxyid' => '1',
    })
    # show respose body
    ret = JSON.parse(res.body)
    raise "Error: #{ret.to_s}" if ret['msg'] != 'Success'
    # return id of the created user
    ret['data']['id']
end

def delete(id)
    url = "#{@url}/api/v1/user/delete"
    body = {
        'api_key' => @key,
        'user_ids' => [id],
    }
    # api call
    res = BlackStack::Netting.call_post(url, body)
    # show respose body
    ret = JSON.parse(res.body)
    # validation
    raise "Error: #{ret.to_s}" if ret['msg'] != 'Success'
end

# open the browser
# return the URL to operate the browser thru selenium
# 
# reference: https://localapi-doc-en.adspower.com/docs/FFMFMf
# 
def open(id)
    uri = URI.parse("#{@url}/api/v1/browser/start?user_id=#{id}")
    res = Net::HTTP.get(uri)
    # show respose body
    ret = JSON.parse(res)
    raise "Error: #{ret.to_s}" if ret['msg'] != 'Success'
    # return id of the created user
    ret['data']['ws']['selenium']
end

id = create
#delete('jc5fiad')