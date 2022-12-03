# googling
Web Service to Request Google Search and Get Results 

## 1. Installation

```bash
gem install googling
```

## 2. Getting Started

```ruby
BlackStack::Google.search('Leandro Sardi "@expandedventure.com"').each { |res|
    puts res.title
    puts res.url
    puts res.abstract
    puts
}
```

## 3. Working with Proxies

```ruby
BlackStack::Google.set_proxies([
    { :ip=>'x01.connectionsphere.com', :port=>4000, :user=>'ls', :password=>'ls4000' }
])
```

## 4. Working with Very Larg Proxies

```ruby
BlackStack::Google.set_proxies([
    { :ip=>'x01.connectionsphere.com', :port=>[4000..4999], :user=>'ls', :password=>'ls4000' }
])
```

