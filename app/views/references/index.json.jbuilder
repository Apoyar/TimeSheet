json.array!(@references) do |reference|
  json.extract! reference, :id, :str_field, :int_field
  json.url reference_url(reference, format: :json)
end
