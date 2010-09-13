# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'pipe'

require "sinatra/reloader" if development?

get '/pipe' do
	content_type 'text/plain', :charset => 'utf-8'
	url = params["url"]
	url = nil if url != nil and url.strip == ''
	if url==nil then 
		return "400 bad request"
	end
	
	url = url.strip
	
	p = {}
	
	q = params["q"]
	q = nil if q != nil and q.strip == ''
	
	if q != nil then
		p[:title] = /#{q}/i
	end

	Pipe.create do
		feed url, :title => /a/i
	end
end
