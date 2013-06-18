json.array!(@shapes) do |shape|
  json.extract! shape, :name, :shape, :user_id, :public
  json.url shape_url(shape, format: :json)
end
