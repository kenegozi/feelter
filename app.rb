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

	feed url #, :title=>params["q"]
end
