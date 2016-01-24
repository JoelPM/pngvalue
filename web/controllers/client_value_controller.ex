defmodule PNGValue.ClientValueController do
  import Plug.Conn

  use PNGValue.Web, :controller

  @default_cache_seconds 24*60*60

  def png(conn, params) do
    case {get_value(conn, params), get_seconds(conn, params)} do
      {nil,_} ->
        conn
        |> put_resp_header("Cache-Control", "private, max-age=0, no-cache")
        |> put_resp_content_type("image/png")
        |> send_resp(200, "")
      {v, s} ->
        conn
        |> put_resp_header("Cache-Control", "private, max-age=#{s}")
        |> put_resp_content_type("image/png")
        |> send_resp(200, to_bin(v))
    end
  end

  defp get_value(conn, params) do
    case get_req_header(conn, "value") do
      [] -> Dict.get(params, "value")
      [v] -> v
    end
  end

  defp get_seconds(conn, params) do
    case get_req_header(conn, "seconds") do
      [] -> Dict.get(params, "seconds", @default_cache_seconds)
      [v] -> v
    end
  end

  defp to_bin(v) do
    v_sz = String.length(v)
    <<v_sz :: size(32)>> <> v |> PNGValue.BinPNG.create
  end
end
