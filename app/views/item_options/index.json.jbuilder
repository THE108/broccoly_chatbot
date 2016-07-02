json.array!(@item_options) do |item_option|
  json.extract! item_option, :id
  json.url item_option_url(item_option, format: :json)
end
