require 'open-uri'
require 'json'

EMAIL = ENV["EMAIL"]
AUTH_KEY = ENV["AUTH_KEY"]

json = JSON.parse(open("https://api.cloudflare.com/client/v4/zones", "X-Auth-Email" => EMAIL, "X-Auth-Key" => AUTH_KEY, "Content-Type" => "application/json").read)

p json["result"].map{ |r| [r["name"], r["id"]] }

