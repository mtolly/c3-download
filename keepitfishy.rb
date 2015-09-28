#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'

unless [1, 2].include? ARGV.length
  STDERR.puts "Usage: #{$0} url [filename]"
  exit 1
end

doc = Nokogiri::HTML(open(ARGV[0]))
refresh = doc.css('meta[http-equiv=Refresh]').attr('content').value
refresh.match(/\A\d+;\s*URL=(.*)\Z/) do |md|
  url = md[1]
  filename = ARGV[1] || (ARGV[0].match(/\?(\w+)\Z/) { |md| md[1] })
  system('wget', "http://keepitfishy.com/#{url}", '-O', filename)
end or exit 1
