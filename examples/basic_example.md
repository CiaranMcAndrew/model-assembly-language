```matlab:Code
filename = fullfile("examples", "mal.yaml")
```

```text:Output
filename = "examples\mal.yaml"
```

```matlab:Code
s = yaml.loadFile(filename)
```

```text:Output
s = 
    stagingDirectory: "submodules"
        instructions: {[1x1 struct]}
        dependencies: {[1x1 struct]  [1x1 struct]}

```

```matlab:Code
instructions = mal.loadInstructions(filename)
```

```text:Output
instructions = 
  ModelAssemblyInstructions with properties:

            Filename: "examples\mal.yaml"
    StagingDirectory: "submodules"
        Instructions: [1x1 mal.ModelAssemblyInstructions]
        Dependencies: [2x1 mal.GitDependency]

```

```matlab:Code
instructions.Instructions
```

```text:Output
ans = 
  ModelAssemblyInstructions with properties:

            Filename: "examples/submal.yaml"
    StagingDirectory: "subs"
        Instructions: []
        Dependencies: [1x1 mal.GitDependency]

```

```matlab:Code
instructions.getDependencyTable()
```

| |url|branch|tag|commit|type|
|:--:|:--:|:--:|:--:|:--:|:--:|
|1|"https://github.com/...|[]|[]|"latest"|"git"|
|2|"www.google.com"|"refs/feature/1"|[]|"abcd1234"|"git"|

```matlab:Code
instructions.getDependencyTable("all")
```

| |url|branch|tag|commit|type|
|:--:|:--:|:--:|:--:|:--:|:--:|
|1|"https://github.com/...|[]|[]|"latest"|"git"|
|2|"www.google.com"|"refs/feature/1"|[]|"abcd1234"|"git"|
|3|"www.facebook.com"|[]|"release/1.2.3"|"latest"|"git"|

```matlab:Code

```
