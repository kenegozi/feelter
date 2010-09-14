# encoding: utf-8
require 'rubygems'
require "sinatra"
require "sinatra/reloader" if development?

require 'open-uri'
require 'simple-rss'
require 'rss/maker'


def get_url
	url = params["url"]
	url = nil if url != nil and url.strip == ''
	url = url.strip if url!=nil
	url
end

def get_query
	q = params["q"]
	q = nil if q != nil and q.strip == ''
	q = q.strip if q != nil
	q
end

get '/pipe' do

	url = get_url
	if url==nil then 
		content_type 'text/plain', :charset => 'utf-8'
		return "400 bad request"
	end
	
	original_feed = open(url)
	
	rss = SimpleRSS.parse original_feed
	
	content_type original_feed.meta['content-type']

	q = get_query
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

