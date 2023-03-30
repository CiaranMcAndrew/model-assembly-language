```matlab:Code
filename = fullfile("examples", "mal.yaml")
```

```text:Output
filename = "examples\mal.yaml"
```

```matlab:Code
disp(fileread(filename));
```

```text:Output
stagingDirectory: submodules

instructions:
- path: examples/submal.yaml

dependencies:
- type: git
  url: https://github.com/CiaranMcAndrew/mal-example-a.git
  commit: latest

- type: git
  name: mal-example-branch
  url: https://github.com/CiaranMcAndrew/mal-example-a.git
  branch: model-branch-a
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
instructions.getDependencyTable()
```

| |Name|Url|Tag|Branch|Commit|Type|
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|1|"mal-example-a.git"|"https://github.com/...|[]|"main"|"latest"|"git"|
|2|"mal-example-branch"|"https://github.com/...|[]|"model-branch-a"|"latest"|"git"|
|3|"www.facebook.com"|"www.facebook.com"|"release/1.2.3"|"main"|"latest"|"git"|

```matlab:Code
instructions.fetchDependencies("local")
```

```text:Output
Adding local git repo: mal-example-a.git - https://github.com/CiaranMcAndrew/mal-example-a.git
Adding local git repo: mal-example-branch - https://github.com/CiaranMcAndrew/mal-example-a.git
```

```matlab:Code
crawlDirectory(instructions.StagingDirectory)
```

```text:Output
mal-example-a.git
-.gitattributes
-.gitignore
-LICENSE
-Malexamplea.prj
-README.md
-mdl
--ModelA.slx
mal-example-branch
-.gitattributes
-.gitignore
-LICENSE
-Malexamplea.prj
-README.md
-mdl
--ModelA.slx
```

```matlab:Code
function crawlDirectory(d, level)

arguments
    d
    level = 0
end

for f = dir(d)'
    if ismember(f.name, {'.','..','.git','resources'})
        continue; 
    end

    disp("" + repmat('-', 1,level) + f.name)

    if f.isdir
        crawlDirectory(fullfile(d,f.name), level+1)
    end
end
end
```
