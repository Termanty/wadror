require 'rails_helper'

describe "BeermappingApi" do
  it "When HTTP GET returns zero entry, empty set is returned" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
    END_OF_STRING
    stub_request(:get, /.*iitti/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("iitti")

    expect(places.size).to eq(0)
  end

  it "When HTTP GET returns one entry, it is parsed and returned" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("espoo")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("Gallows Bird")
    expect(place.street).to eq("Merituulentie 30")
  end

  it "When HTTP GET returns multiple entries, they are parsed and returned" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>17044</id><name>Teerenpeli</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=17044</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=17044&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=17044&amp;d=1&amp;type=norm</blogmap><street>Vapaudenkatu 20</street><city>Lahti</city><state></state><zip>15110</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location><location><id>18853</id><name>Teerenpeli</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=18853</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18853&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18853&amp;d=1&amp;type=norm</blogmap><street>Liimaajankatu 9</street><city>Lahti</city><state></state><zip>15520</zip><country>Finland</country><phone>0424 925 240</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
END_OF_STRING

    stub_request(:get, /.*lahti/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("lahti")

    expect(places.size).to eq(2)
    place = places.first
    expect(place.name).to eq("Teerenpeli")
    expect(place.street).to eq("Vapaudenkatu 20")
    place =  places.second
    expect(place.name).to eq("Teerenpeli")
    expect(place.street).to eq("Liimaajankatu 9")
  end

end