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
        dependencies: {[1x1 struct]}

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
        Dependencies: [1x1 mal.GitDependency]

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

| |Name|Url|Tag|Branch|Commit|Type|
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|1|"mal-example-a.git"|"https://github.com/...|[]|"main"|"latest"|"git"|
|2|"www.facebook.com"|"www.facebook.com"|"release/1.2.3"|"main"|"latest"|"git"|

```matlab:Code
% instructions.getDependencyTable("local")
```

```matlab:Code
instructions.fetchDependencies("local")
```

```text:Output
Adding local git repo: mal-example-a.git - https://github.com/CiaranMcAndrew/mal-example-a.git
```

![image_0.png](basic_example_images/image_0.png)
