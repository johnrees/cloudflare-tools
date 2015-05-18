#!/usr/bin/env ruby

require 'open-uri'
require 'json'

# Usage `EMAIL=(email) AUTH_KEY=(api_key) ruby cf.rb`

EMAIL = ENV.fetch("EMAIL")
AUTH_KEY = ENV.fetch("AUTH_KEY")

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

while (puts zones.keys.sort; print "> "; input = gets) do
  input.chomp!
  puts "Input was: #{input.inspect}"
  case input
  when *zones.keys then puts get_json("https://api.cloudflare.com/client/v4/zones/#{zones[input]}/dns_records")
  when "q", "quit", "exit" then break
  else puts "I don't know that command"
  end
end

# 2. Ask for command -
#   Backup DNS records
#   Restore DNS records
#   Copy DNS records from another domain
#   Delete all DNS records
#   Add Google Apps DNS

