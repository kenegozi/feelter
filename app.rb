# encoding: utf-8
require 'rubygems'
require 'simple-rss'
require 'open-uri'
require "sinatra"

require "sinatra/reloader" if development?

require 'rss/maker'

get '/pipe' do
	content_type 'text/plain', :charset => 'utf-8'

	url = params["url"]
	url = nil if url != nil and url.strip == ''
	if url==nil then 
		return "400 bad request"
	end
	
	url = url.strip
	
	
	rss = SimpleRSS.parse open(url)

	q = params["q"]
	q = nil if q != nil and q.strip == ''
	q = q.strip if q != nil

	if q != nil then
		rss.items.reject!{|i| (i.title =~ /#{q}/i) == nil }
	end
	
	SimpleRSS.send(:public, :title)
	SimpleRSS.send(:public, :link)
	content = RSS::Maker.make("2.0") do |m|
		m.channel.title = rss.title
		m.channel.link = rss.link
		m.channel.description = rss.title
		m.items.do_sort = true # sort items by date
  
		rss.items.each do |item|
			i = m.items.new_item
			i.title = item.title
			i.link = item.link
			i.date = item.updated
			i.content_encoded = item.content_encoded
			i.content_encoded = item.content if item.content_encoded == nil
		end

	end

	content.to_s
end

