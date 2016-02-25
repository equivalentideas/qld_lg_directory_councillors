require "open-uri"
require "openssl"
require "json"
require "scraperwiki"

def create_id(council, name)
  components = council + "/" + name
  components.downcase.gsub(" ","_")
end

url = "https://services.dsdip.qld.gov.au/lgguide/sampleData/lgaInfo.json"

councils = JSON.parse(open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read)

councils.each do |council|
  #p council
  council_name = council["council_name"]
  council_website = council["website_url"]

  record = {
    "id" => create_id(council_name, council["mayor"]),
    "councillor" => council["mayor"],
    "position" => "mayor",
    "council_name" => council_name,
    "council_website" => council_website,
    "council_email" => council["email"]
  }

  p record
  ScraperWiki.save_sqlite(["councillor", "council_name"], record)

  councillors = council["councilors"]

  councillors.each do |councillor|
    record = {
      "id" => create_id(council_name, councillor["name"]),
      "councillor" => councillor["name"],
      "council_name" => council_name,
      "council_website" => council_website,
      "council_email" => council["email"]
    }

    p record
    ScraperWiki.save_sqlite(["councillor", "council_name"], record)
  end
end
