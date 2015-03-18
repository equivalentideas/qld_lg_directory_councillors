require "open-uri"
require "openssl"
require "json"
require "scraperwiki"

url = "https://services.dsdip.qld.gov.au/lgguide/sampleData/lgaInfo.json"

councils = JSON.parse(open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read)

councils.each do |council|
  #p council
  council_name = council["council_name"]
  council_website = council["website_url"]
  record = {
    "councillor" => council["mayor"],
    "position" => "mayor",
    "council_name" => council_name,
    "council_website" => council_website
  }
  p record
  ScraperWiki.save_sqlite(["councillor", "council_name"], record)
  councillors = council["councilors"]
  councillors.each do |councillor|
    record = {
      "councillor" => councillor["name"],
      "council_name" => council_name,
      "council_website" => council_website
    }
    p record
    ScraperWiki.save_sqlite(["councillor", "council_name"], record)
  end
end
