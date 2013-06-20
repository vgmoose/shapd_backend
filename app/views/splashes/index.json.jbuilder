json.array!(@splashes) do |splash|
  json.extract! splash, :email
  json.url splash_url(splash, format: :json)
end
