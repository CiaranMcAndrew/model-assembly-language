# Example A - Writing Instructions
## Instruction set

This example feature an instruction set that shows several methods of defining a dependency:

   1.  By referring to a git repository without specifying any additional configuration - this will return the HEAD of the default branch. 
   1.  By specifying a branch of a git repository - this will return the HEAD of that branch. 
   1.  By specifying a tag 
   1.  By specifying a commit id 
   1.  By loading a seperate instructions file containing its own dependency 

## Read the yaml file

```matlab:Code
filename = fullfile("examples", "example-a-basic-usage", "example-a.yaml")
```

```text:Output
filename = "examples\example-a-basic-usage\example-a.yaml"
```

```matlab:Code
disp(fileread(filename));
```

```text:Output
stagingDirectory: submodules/example-a

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

- type: git
  name: mal-example-commit
  url: https://github.com/CiaranMcAndrew/mal-example-a.git
  commit: 3ba5d0d
```

## Create an instruction set

```matlab:Code
instructions = mal.loadInstructions(filename)
```

```text:Output
instructions = 
  ModelAssemblyInstructions with properties:

            Filename: "examples\example-a-basic-usage\example-a.yaml"
    StagingDirectory: "submodules/example-a"
        Instructions: [1x1 mal.ModelAssemblyInstructions]
        Dependencies: [4x1 mal.GitDependency]
              Values: []

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
|4|"mal-example-commit"|"https://github.com/...|[]|"main"|"3ba5d0d"|"git"|0x0 mal.ModelAssembl...|
|5|"model-subref"|"https://github.com/...|[]|"main"|"latest"|"git"|0x0 mal.ModelAssembl...|

## Fetch local depedencies

```matlab:Code
instructions.fetchDependencies()
```

```text:Output
Adding local git repo: mal-example-a.git - https://github.com/CiaranMcAndrew/mal-example-a.git
Adding local git repo: mal-example-branch - https://github.com/CiaranMcAndrew/mal-example-a.git
Adding local git repo: mal-example-tag - https://github.com/CiaranMcAndrew/mal-example-a.git
Adding local git repo: mal-example-commit - https://github.com/CiaranMcAndrew/mal-example-a.git
Adding local git repo: model-subref - https://github.com/CiaranMcAndrew/mal-example-a.git
```

## Show all referenced files

```matlab:Code
crawlDirectory(instructions.StagingDirectory)
```

```text:Output
mal-example-a.git\
-.gitattributes
-.gitignore
-LICENSE
-Malexamplea.prj
-README.md
-mdl\
--ModelA.slx
mal-example-branch\
-.gitattributes
-.gitignore
-LICENSE
-Malexamplea.prj
-README.md
-mdl\
--ModelA.slx
mal-example-commit\
-.gitattributes
-.gitignore
-LICENSE
-Malexamplea.prj
-README.md
-mdl\
--ModelA.slx
mal-example-tag\
-.gitattributes
-.gitignore
-LICENSE
-Malexamplea.prj
-README.md
-mdl\
--ModelA.slx
model-subref\
-.gitattributes
-.gitignore
-LICENSE
-Malexamplea.prj
-README.md
-mdl\
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
git status for : mal-example-branch
On branch model-branch-a
Your branch is up to date with 'origin/model-branch-a'.

nothing to commit, working tree clean
--------------------
git status for : mal-example-commit
On branch main
Your branch is up to date with 'origin/main'.

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
