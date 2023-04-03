# Example B - Using Sub Instructions
## Instruction set

Example B instructions contains a dependency with reference to another instruction set, this time contained in the dependency repo.

```matlab:Code
filename = fullfile("examples", "example-b-sub-instructions", "example-b.yaml")
```

```text:Output
filename = "examples\example-b-sub-instructions\example-b.yaml"
```

```matlab:Code
disp(fileread(filename));
```

```text:Output
stagingDirectory: submodules/example-b

dependencies:
- type: git
  url: https://github.com/CiaranMcAndrew/mal-example-b.git
  instructions: mal.yaml
```

## Load the Instruction set and preview

```matlab:Code
instructions = mal.loadInstructions(filename)
```

```text:Output
instructions = 
  ModelAssemblyInstructions with properties:

            Filename: "examples\example-b-sub-instructions\example-b.yaml"
    StagingDirectory: "submodules/example-b"
        Instructions: []
        Dependencies: [1x1 mal.GitDependency]
              Values: []

```

At this stage, we only know of first order instructions, as show here:

```matlab:Code
disp(instructions.toYaml)
```

```text:Output
Filename: examples\example-b-sub-instructions\example-b.yaml
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
    StagingDirectory: subs
    Instructions: []
    Dependencies: []
    Values: []
Values: []
```

## `Fetch Instructions to populate the hierarchy`

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
Filename: examples\example-b-sub-instructions\example-b.yaml
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
```

Note that the 2nd tier instructions have now been populated.

We can now run a `fetchDependencies `command to get all dependencies in the hierarchy.

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
git status for : mal-example-b.git
On branch main
Your branch is up to date with 'origin/main'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	submodules/

nothing added to commit but untracked files present (use "git add" to track)
--------------------
```
