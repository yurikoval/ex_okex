%{
  configs: [
    %{
      name: "default",
      color: true,
      files: %{excluded: [~r"/_build/", ~r"/deps/", ~r"/test/"]},
      checks: [{Credo.Check.Readability.ModuleDoc, false}]
    }
  ]
}
