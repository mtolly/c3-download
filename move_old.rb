#!/usr/bin/env ruby

require 'yaml'
require 'fileutils'

if ARGV.length != 1
  STDERR.puts "Usage: #{$0} in.yaml"
  exit 1
end
yaml = YAML.load_file(ARGV[0])['data']
prefix = 'http://keepitfishy.com/d.php?'
FileUtils.mkdir_p('oldcons/')

files = []
yaml.each do |song|
  url = song['CustomDownloadURL']
  if url && url =~ /\S/
    if url.start_with?(prefix)
      filename = "cons/#{url[prefix.length..-1]}"
      files << filename
      files << "#{filename}.zip"
      files << "#{filename}.rar"
    end
  end
end

(Dir['cons/*'] - files).each do |f|
  puts "Moving unused file #{f}"
  FileUtils.mv(f, 'old' + f)
end
