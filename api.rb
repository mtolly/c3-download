#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'yaml'

if ARGV.length != 1
  STDERR.puts "Usage: #{$0} out.yaml"
  exit 1
end
out_yaml = ARGV[0]

uri = URI('http://pksage.com/songlist/php/songlist.php')
params = {
  _dc: Time.now.to_i * 1000,
  whichGame: 'rb',
  andor: '',
  page: 1,
  start: 0,
  limit: 0x0916173,
  sort: [
    {property: 'ReleasedOn', direction: 'DESC'},
    {property: 'Source', direction: 'ASC'},
    {property: 'PackName', direction: 'ASC'},
    {property: 'Artist', direction: 'ASC'},
    {property: 'FullName', direction: 'ASC'},
  ].to_json,
  filter: [
    {property: 'Source', value: 'Custom|is'},
  ].to_json,
}
uri.query = URI.encode_www_form(params)
res = Net::HTTP.get_response(uri)
if res.is_a?(Net::HTTPSuccess)
  File.write(out_yaml, JSON.parse(res.body).to_yaml)
else
  STDERR.puts res.inspect
  exit 1
end
