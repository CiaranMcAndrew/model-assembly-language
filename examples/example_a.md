## Read the yaml file

```matlab:Code
filename = fullfile("examples", "example-a.yaml")
```

```text:Output
filename = "examples\example-a.yaml"
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

- type: git
  name: mal-example-branch
  url: https://github.com/CiaranMcAndrew/mal-example-a.git
  branch: model-branch-a

- type: git
  name: mal-example-tag
  url: https://github.com/CiaranMcAndrew/mal-example-a.git
  tag: release/1.0.0
```

## Create an instruction set

```matlab:Code
instructions = mal.loadInstructions(filename)
```

```text:Output
instructions = 
  ModelAssemblyInstructions with properties:

            Filename: "examples\example-a.yaml"
    StagingDirectory: "submodules"
        Instructions: [1x1 mal.ModelAssemblyInstructions]
        Dependencies: [3x1 mal.GitDependency]

```

## View dependencies in a table

```matlab:Code
instructions.getDependencyTable()
```

| |Name|Url|Tag|Branch|Commit|Type|Instructions|
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
|1|"mal-example-a.git"|"https://github.com/...|[]|"main"|"latest"|"git"|0x0 mal.ModelAssembl...|
|2|"mal-example-branch"|"https://github.com/...|[]|"model-branch-a"|"latest"|"git"|0x0 mal.ModelAssembl...|
|3|"mal-example-tag"|"https://github.com/...|"release/1.0.0"|"main"|"latest"|"git"|0x0 mal.ModelAssembl...|
|4|"model-subref"|"https://github.com/...|[]|"main"|"latest"|"git"|0x0 mal.ModelAssembl...|

## Fetch local depedencies

```matlab:Code
instructions.fetchDependencies()
```

```text:Output
Adding local git repo: mal-example-a.git - https://github.com/CiaranMcAndrew/mal-example-a.git
Adding local git repo: mal-example-branch - https://github.com/CiaranMcAndrew/mal-example-a.git
Adding local git repo: mal-example-tag - https://github.com/CiaranMcAndrew/mal-example-a.git
Adding local git repo: model-subref - https://github.com/CiaranMcAndrew/mal-example-a.git
```

## Show all referenced files

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
mal-example-branch
-.gitattributes
-.gitignore
-LICENSE
-Malexamplea.prj
-README.md
-mdl
--ModelA.slx
mal-example-tag
-.gitattributes
-.gitignore
-LICENSE
-Malexamplea.prj
-README.md
-mdl
--ModelA.slx
model-subref
-.gitattributes
-.gitignore
-LICENSE
-Malexamplea.prj
-README.md
-mdl
--ModelA.slx
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
git status for : mal-example-a.git
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
--------------------
git status for : mal-example-b.git
HEAD detached at refs/heads/main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	submodules/

nothing added to commit but untracked files present (use "git add" to track)
--------------------
git status for : mal-example-branch
On branch model-branch-a
Your branch is up to date with 'origin/model-branch-a'.

nothing to commit, working tree clean
--------------------
git status for : mal-example-tag
HEAD detached at release/1.0.0
nothing to commit, working tree clean
--------------------
git status for : model-subref
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
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
