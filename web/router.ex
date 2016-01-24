defmodule PNGValue.Router do
  use PNGValue.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PNGValue do
    pipe_through :api
  end

  pipeline :png do
    plug :accepts, ["image/png"]
  end

  scope "/", PNGValue do
    pipe_through :png

    get "/*path", ClientValueController, :png
  end
end
