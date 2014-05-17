json.array!(@posts) do |post|
  json.extract! post, :id, :user_id, :votes, :parent_id, :img_url
  json.url post_url(post, format: :json)
end
