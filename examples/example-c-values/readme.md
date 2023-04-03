# Example C - Using Values to Configure Dependencies
## Instruction set

Example C instructions extend those from Example B with the following additions:

   1.  The `instructions` attribute to reference another instruction set. 
   1.  The `values `attribute overwrite configuration within an instruction hierarchy. 

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

instructions:
- path: examples/example-b-sub-instructions/example-b.yaml

values:
- name: mal-example-b.git
  value: 
  - name: mal-example-a.git
    value: 
    - name: tag
      value: release/1.0.0
```

## Load the Instruction set and preview

```matlab:Code
instructions = mal.loadInstructions(filename)
```

```text:Output
instructions = 
  ModelAssemblyInstructions with properties:

            Filename: "examples\example-c-values\example-c.yaml"
    StagingDirectory: "submodules/example-c"
        Instructions: [1x1 mal.ModelAssemblyInstructions]
        Dependencies: [0x0 mal.Dependency]
              Values: {[1x1 struct]}

```

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
Instructions:
  Filename: examples/example-b-sub-instructions/example-b.yaml
  StagingDirectory: submodules/example-b
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
  Values: []
Dependencies: []
Values:
- name: mal-example-b.git
  value:
  - name: mal-example-a.git
    value:
    - {name: tag, value: release/1.0.0}
```

`fetchInstructions` has built the full instruction hierarchy. By calling `applyValues` we can overwrite these instructions with a specfic configuration.

```matlab:Code
instructions.applyValues
disp(instructions.toYaml)
```

```text:Output
Filename: examples\example-c-values\example-c.yaml
StagingDirectory: submodules/example-c
Instructions:
  Filename: examples/example-b-sub-instructions/example-b.yaml
  StagingDirectory: submodules/example-b
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
  Values: []
Dependencies: []
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

## Show all staged files

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
