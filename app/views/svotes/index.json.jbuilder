json.array!(@svotes) do |svote|
  json.extract! svote, :id
  json.url svote_url(svote, format: :json)
end
