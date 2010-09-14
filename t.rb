require 'rubygems'
require 'simple-rss'
require 'open-uri'

rss = SimpleRSS.parse open('http://feeds.feedburner.com/kenegozi')

q = "\.NET|Action"


rss.items.reject!{|i| (i.title =~ /#{q}/i) == nil }

print rss.items.first.title + "\n"

print rss.items.size.to_s + "\n"


#http://blogs.microsoft.co.il/blogs/pintyo/rss.aspx