defmodule Mix.Tasks.Release.Container do
  use Mix.Task

  @root    Path.expand("../../../", __DIR__)

  @dockerfile Path.expand("../../../Dockerfile.gen", __DIR__)

  @shortdoc "Build a docker image for this application."

  def run([]) do
    run("Dockerfile")
  end

  def run(name) do
    IO.puts("Got name: \"#{name}\"")
    
    template   = Path.join(@root, "#{name}.eex")
    dockerfile = Path.join(@root, name)

    IO.puts "template: #{template}, dockerfile: #{dockerfile}"

    conf = Mix.Project.config
    contents = EEx.eval_file template, conf
    File.write!(dockerfile, contents)
 
    Mix.Task.run "release", []

    docker_cmd = "docker build -t #{to_string(conf[:app])} -f #{name} ."

    Mix.Shell.IO.info docker_cmd

    Mix.Shell.cmd docker_cmd, &(IO.puts(&1))
  end
end
