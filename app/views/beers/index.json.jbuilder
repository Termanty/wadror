json.array!(@beers) do |beer|
  json.extract! beer, :id, :name, :styles, :brewery_id
  json.url beer_url(beer, format: :json)
end
