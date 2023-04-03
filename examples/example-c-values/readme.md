# Example C - Using Values to Configure Dependencies
## Read the yaml file

```matlab:Code
filename = fullfile("examples", "example-c-values", "example-c.yaml")
```

```text:Output
filename = "examples\example-c-values\example-c.yaml"
```

```matlab:Code
disp(fileread(filename));
```

```text:Output
stagingDirectory: submodules/example-c

dependencies:
- type: git
  url: https://github.com/CiaranMcAndrew/mal-example-b.git
  instructions: mal.yaml

values:
- name: mal-example-b.git
  value: 
  - name: mal-example-a.git
    value: 
    - name: tag
      value: release/1.0.0
```

## Create an instruction set

```matlab:Code
instructions = mal.loadInstructions(filename)
```

```text:Output
instructions = 
  ModelAssemblyInstructions with properties:

            Filename: "examples\example-c-values\example-c.yaml"
    StagingDirectory: "submodules/example-c"
        Instructions: []
        Dependencies: [1x1 mal.GitDependency]
              Values: {[1x1 struct]}

```

## View dependencies in a table

```matlab:Code
instructions.getDependencyTable()
```

| |Name|Url|Tag|Branch|Commit|Type|Instructions|
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|1|"mal-example-b.git"|"https://github.com/...|[]|"main"|"latest"|"git"|1x1 struct|

## Preview instructions

At this stage, we only know of first order instructions, as show here:

```matlab:Code
disp(instructions.toYaml)
```

```text:Output
Filename: examples\example-c-values\example-c.yaml
StagingDirectory: submodules/example-c
Instructions: []
Dependencies:
  Name: mal-example-b.git
  Url: https://github.com/CiaranMcAndrew/mal-example-b.git
  Tag: []
  Branch: main
  Commit: latest
  Type: git
  Instructions:
    Filename: mal.yaml
    StagingDirectory: subs
    Instructions: []
    Dependencies: []
    Values: []
Values:
- name: mal-example-b.git
  value:
  - name: mal-example-a.git
    value:
    - {name: tag, value: release/1.0.0}
```

`fetchInstructions` will perform a recursive sparse checkout on the instruction hierachy to build the complete instruction set. This is useful for validating the instruction set before execution a full `fetchDependencies` command.

```matlab:Code
instructions.fetchInstructions
```

```text:Output
Adding local git repo: mal-example-b.git - https://github.com/CiaranMcAndrew/mal-example-b.git
```

```matlab:Code
disp(instructions.toYaml)
```

```text:Output
Filename: examples\example-c-values\example-c.yaml
StagingDirectory: submodules/example-c
Instructions: []
Dependencies:
  Name: mal-example-b.git
  Url: https://github.com/CiaranMcAndrew/mal-example-b.git
  Tag: []
  Branch: main
  Commit: latest
  Type: git
  Instructions:
    Filename: mal.yaml
    StagingDirectory: submodules
    Instructions: []
    Dependencies:
      Name: mal-example-a.git
      Url: https://github.com/CiaranMcAndrew/mal-example-a.git
      Tag: []
      Branch: main
      Commit: latest
      Type: git
      Instructions: []
    Values: []
Values:
- name: mal-example-b.git
  value:
  - name: mal-example-a.git
    value:
    - {name: tag, value: release/1.0.0}
```

```matlab:Code
instructions.applyValues
disp(instructions.toYaml)
```

```text:Output
Filename: examples\example-c-values\example-c.yaml
StagingDirectory: submodules/example-c
Instructions: []
Dependencies:
  Name: mal-example-b.git
  Url: https://github.com/CiaranMcAndrew/mal-example-b.git
  Tag: []
  Branch: main
  Commit: latest
  Type: git
  Instructions:
    Filename: mal.yaml
    StagingDirectory: submodules
    Instructions: []
    Dependencies:
      Name: mal-example-a.git
      Url: https://github.com/CiaranMcAndrew/mal-example-a.git
      Tag: release/1.0.0
      Branch: main
      Commit: latest
      Type: git
      Instructions: []
    Values: []
Values:
- name: mal-example-b.git
  value:
  - name: mal-example-a.git
    value:
    - {name: tag, value: release/1.0.0}
```

## Fetch depedencies

```matlab:Code
instructions.fetchDependencies()
```

```text:Output
Adding local git repo: mal-example-b.git - https://github.com/CiaranMcAndrew/mal-example-b.git
Creating staging directory: submodules
Adding local git repo: mal-example-a.git - https://github.com/CiaranMcAndrew/mal-example-a.git
```

## Show all referenced files

```matlab:Code
crawlDirectory(instructions.StagingDirectory)
```

```text:Output
mal-example-b.git\
-.gitattributes
-.gitignore
-LICENSE
-README.md
-mal-example-b.prj
-mal.yaml
-submodules\
--mal-example-a.git\
---.gitattributes
---.gitignore
---LICENSE
---Malexamplea.prj
---README.md
---mdl\
----ModelA.slx
```
