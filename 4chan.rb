#! /usr/bin/env ruby
require 'nokogiri'
require 'open-uri'

boards = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'gif', 'h', 'hr', 'k', 'm', 'o', 'p', 'r', 's', 't', 'u', 'v', 'vg', 'w', 'wg', 'i', 'ic', 'r9k', 'cm', 'hm', 'y', '3', 'adv', 'an', 'cgl', 'ck', 'co', 'diy', 'fa', 'fit', 'hc', 'int', 'jp', 'lit', 'mlp', 'mu', 'n', 'po', 'pol', 'sci', 'soc', 'sp', 'tg', 'toy', 'trv', 'tv', 'vp', 'x']

abort "Board required. Availables: /#{boards.join('/')}/" if ARGV.length == 0
board = ARGV[0]
page	= ARGV[1] || ?0

abort 'There are only 16 pages (0-15).' if page.to_i > 15
abort "/#{board}/ does not exist in 4chan." unless boards.include? board

dir = "#{board}_#{Time.now.getutc.to_s.gsub(/\s+/, '')}"
Dir::mkdir(dir) unless File.directory? dir

Nokogiri::HTML(open("http://boards.4chan.org/#{board}/#{page}")).xpath('//a[@class = "replylink"]/@href').map { |url|
   Thread.new do
      Nokogiri::HTML(open("http://boards.4chan.org/#{board}/#{url}")).xpath('//a[@class = "fileThumb"]/@href').each { |p|
         filename = File.basename(p)
         puts '#> ' + filename
		   open("#{dir}/#{filename}", ?w) do |file|
			   file << open("http:#{p}").read
		   end
	   }
   end
}.each(&:join)

puts "Downloaded #{Dir.entries(dir).size} files."
puts "You can find your images in #{dir} :3"
