defmodule Spotify.AuthRequest do
  @moduledoc false

  @url "https://accounts.spotify.com/api/token"

  def post(params) do
    client = headers()
    Tesla.post(client, @url, params)
  end

  def headers() do
    middleware = [
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "Basic #{Spotify.encoded_credentials()}"},
         {"Content-Type", "application/x-www-form-urlencoded"}
       ]}
    ]

    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
    Tesla.client(middleware, adapter)
  end
end
