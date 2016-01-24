defmodule Mix.Tasks.PNGValue.Docker.Build do
  use Mix.Task

  @template Path.expand("../../../Dockerfile.eex", __DIR__)

  @shortdoc "Build a docker image for this application."

  def run(_) do
    Mix.Task.run "release", []
    
    IO.puts "Magic!: #{@template}"
  end
end
