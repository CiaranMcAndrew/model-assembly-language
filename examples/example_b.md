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
    StagingDirectory: subs
    Instructions: []
    Dependencies: []
```

## Fetch local depedencies

```matlab:Code
instructions.fetchDependencies()
```

## Show all referenced files

```matlab:Code
crawlDirectory(instructions.StagingDirectory)
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
