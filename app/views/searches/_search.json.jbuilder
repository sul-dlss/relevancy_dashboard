json.extract! search, :id, :query_params, :created_at, :updated_at, :score
json.url search_url(search, format: :json)
