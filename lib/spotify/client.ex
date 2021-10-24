defmodule Spotify.Client do
  @moduledoc false

  def get(conn_or_creds, url) do
    client = get_headers(conn_or_creds)
    Tesla.get(client, url)
  end

  def put(conn_or_creds, url, body \\ "") do
    client = put_headers(conn_or_creds)
    Tesla.put(client, url, body)
  end

  def post(conn_or_creds, url, body \\ "") do
    client = post_headers(conn_or_creds)
    Tesla.post(client, url, body)
  end

  def delete(conn_or_creds, url) do
    client = delete_headers(conn_or_creds)
    Tesla.delete(client, url)
  end

  def get_headers(conn_or_creds) do
    middleware = [
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "Bearer #{access_token(conn_or_creds)}"}
       ]}
    ]
    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}

    Tesla.client(middleware, adapter)
  end

  def put_headers(conn_or_creds) do
    middleware = [
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "Bearer #{access_token(conn_or_creds)}"},
         {"Content-Type", "application/json"}
       ]}
    ]
    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}
    Tesla.client(middleware, adapter)
  end

  defp access_token(conn_or_creds) do
    Spotify.Credentials.new(conn_or_creds).access_token
  end

  def post_headers(conn_or_creds), do: put_headers(conn_or_creds)
  def delete_headers(conn_or_creds), do: get_headers(conn_or_creds)
end
