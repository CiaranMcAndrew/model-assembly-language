## Read the yaml file

```matlab:Code
filename = fullfile("examples", "example-b.yaml")
```

```text:Output
filename = "examples\example-b.yaml"
```

```matlab:Code
disp(fileread(filename));
```

```text:Output
stagingDirectory: submodules

dependencies:
- type: git
  url: https://github.com/CiaranMcAndrew/mal-example-b.git
  instructions: mal.yaml
```

## Create an instruction set

```matlab:Code
instructions = mal.loadInstructions(filename)
```

```text:Output
instructions = 
  ModelAssemblyInstructions with properties:

            Filename: "examples\example-b.yaml"
    StagingDirectory: "submodules"
        Instructions: []
        Dependencies: [1x1 mal.GitDependency]

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
Filename: examples\example-b.yaml
StagingDirectory: submodules
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
Filename: examples\example-b.yaml
StagingDirectory: submodules
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
```

## Fetch local depedencies

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
mal-example-b.git
-.gitattributes
-.gitignore
-LICENSE
-README.md
-mal-example-b.prj
-mal.yaml
-submodules
--mal-example-a.git
---.gitattributes
---.gitignore
---LICENSE
---Malexamplea.prj
---README.md
---mdl
----ModelA.slx
```

## Confirm git status of references

```matlab:Code
wd = pwd;
for f = dir(instructions.StagingDirectory)'
    if ismember(f.name, {'.','..'}); continue; end
    
    disp("git status for : " + f.name)
    cd(fullfile(instructions.StagingDirectory, f.name))
    !git status
    cd(wd)
    disp("--------------------")
end
```

```text:Output
git status for : mal-example-b.git
On branch main
Your branch is up to date with 'origin/main'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	submodules/

nothing added to commit but untracked files present (use "git add" to track)
--------------------
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
