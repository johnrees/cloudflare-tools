#!/usr/bin/env ruby

require 'open-uri'
require 'json'

# Usage `EMAIL=(email) AUTH_KEY=(api_key) ruby cf.rb`

EMAIL = ENV.fetch("EMAIL")
AUTH_KEY = ENV.fetch("AUTH_KEY")

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end

end

def get_json url
  JSON.parse(open(
    url,
    "X-Auth-Email" => EMAIL,
    "X-Auth-Key" => AUTH_KEY,
    "Content-Type" => "application/json"
  ).read)
end

# 1. Ask for a domain

zones = get_json("https://api.cloudflare.com/client/v4/zones")
zones = zones["result"].collect{ |r| {r["name"] => r["id"]} }.inject(:merge)

puts zones.keys.sort

while (print "Type a domain > ".yellow; domain = gets) do
  domain.chomp!
  puts "Input was: #{domain.inspect}".pink
  case domain
  when *zones.keys then break
  when "q", "quit", "exit" then break
  else puts "I don't know that command. Please enter something like #{zones.keys.sample}"
  end
end

# 2. Ask for an option

options = [
  'Backup DNS records',
  'Restore DNS records from a previous backup',
  'Copy DNS records from another cloudflare domain',
  'Delete all DNS records',
  'Add Google Apps DNS'
]

puts options.map.with_index(1).map{|q,i| "#{i}) #{q}" }

while (print "Choose an option (1-#{options.length}) > ".yellow; option = gets) do
  option.chomp!
  puts "Input was: #{option.inspect}".pink
  case option
  when '1' then puts 'backup'
  when '2' then puts 'restore'
  when '3' then puts 'copy'
  when '4' then puts 'delete'
  when '5' then puts 'google'
  when "q", "quit", "exit" then break
  else puts "I don't know that command. Please enter an integer between 1 and #{options.length}"
  end
end

# puts get_json("https://api.cloudflare.com/client/v4/zones/#{zones[input]}/dns_records")
