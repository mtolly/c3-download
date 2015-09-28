#!/usr/bin/env ruby

require 'yaml'
require 'fileutils'

if ARGV.length != 1
  STDERR.puts "Usage: #{$0} in.yaml"
  exit 1
end
yaml = YAML.load_file(ARGV[0])['data']
FileUtils.mkdir_p('cons/')

prefix = 'http://keepitfishy.com/d.php?'
yaml.each do |song|
  url = song['CustomDownloadURL']
  if url && url =~ /\S/
    if url.start_with?(prefix)
      filename = "cons/#{url[prefix.length..-1]}"
      if File.exist?(filename)
        puts "#{filename} already exists."
      elsif File.exist?("#{filename}.zip")
        puts "#{filename}.zip already exists."
      elsif File.exist?("#{filename}.rar")
        puts "#{filename}.rar already exists."
      else
        `./keepitfishy.rb #{url} #{filename}`
        magic = File.open(filename, 'rb') { |f| f.gets(4) }
        if magic == "PK\x03\x04"
          FileUtils.mv filename, "#{filename}.zip"
        elsif magic == "Rar!"
          FileUtils.mv filename, "#{filename}.rar"
        end
        sleep 5
      end
    else
      puts "Couldn't parse URL: #{url}"
      exit 1
    end
  end
end
