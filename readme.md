<div align="center">

# Model Assembly Language

[The Problem](#what-problem-does-this-solve) •
[Features](#what-does-this-do) •
[Quick Guide](#quick-guide) •
[Requirements](#requirements) •
[Detailed Guide](#detailed-guide) •
[Examples](#examples) •
[Contributing](#contributing) •
[License](#license)

[![View on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/127419-model-assembly-language)
[![MIT License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
![language](https://shields.io/github/languages/top/CiaranMcAndrew/model-assembly-language)
[![Latest Release](https://shields.io/github/v/release/CiaranMcAndrew/model-assembly-language?display_name=tag)](https://github.com/CiaranMcAndrew/model-assembly-language/releases/latest)

</div>

---

## What Problem does this Solve?

Complex systems require complex models.

Imagine this scenario:

* Global automotive company Fred are designing a new model of their popular Mondo family saloon.
* A complex organisation are working on a range of models across the entire product hierarchy. Each team have their own Git repository containing their model files.
* The Vehicle Integration Team need to take models from several teams and build and test a full model of the Mondo.
* The Electric Battery Supercoolant Pump team have just developed a new design. The business wants to quickly evaluate its performance in a Vehicle Integration level simulation. 
* However, the pump component is abstracted by several layers of product hierarchy from the Vehicle Integration level, and integrating these changes would create work at each of these layers, and cause a configuration control challenge as the pump is still on a model branch and has not been fully tested or reviewed.

The Model Assembly Language attempts to support large-scale modelling teams (or teams of teams) with challenges similar to this. It provides a simple, flexible and human-readable alternative to methods such as Git submodules for integrating many model dependencies of various baselines, whilst allowing appropriate rigour as the assembly instructions are plain-text and can be managed in configuration control.


## What does this do?

* The Model Assembly Lanuage `MAL` is a structured language inspired by [Helm](https://helm.sh/) for use with [MATLAB](https://uk.mathworks.com/products/matlab.html).
* It enables a user to specify the dependencies for a project in a flexible yaml-based approach.
* Dependencies can cascade, allowing hierarchical expansion of a model structure.
* The `MAL` enables precise control of the configuration of model hierachy, including branch, tag, and commit referencing, including injection of a lower-level configuration.

## Quick Guide

In your local project, specify a list of dependencies by writing an Instruction set `mal.yaml` as follows:

```yaml 
dependencies:
- type: git
  url: https://github.com/<MyOrganisation>/component-a.git

- type: git
  url: https://github.com/<MyOrganisation>/component-b.git
  branch: feature/new-gizmo

- type: git
  url: https://github.com/<MyOrganisation>/component-c.git
  tag: release/1.0.3
```
---

## Requirements

* [MATLAB](https://uk.mathworks.com/products/matlab.html)
  * Developed using R2023a
  * _Should_ work from R2020a (untested)
* [Git](https://git-scm.com/)
* [yaml for MATLAB](https://uk.mathworks.com/matlabcentral/fileexchange/106765-yaml?s_tid=FX_rc3_behav) by Martin Koch

---

Then, fetch your dependencies using the following:

```matlab
mal.fetchInstructionSet("mal.yaml")
```

The dependencies will then be checked-out into the `submodules/<dependencyName>` folder.

## Detailed Guide

An Instruction set is a `.yaml` file. It can be in any project directory and have any name. When loaded, it will be translated into a [`mal.ModelAssemblyInstructions`](src/%2Bmal/ModelAssemblyInstructions.m) object.

Full example:

```yaml
stagingDirectory: project/submodules

instructions:
- path: instructions/assembly.yaml
- path: instructions/config.yaml

dependencies:
- type: git
  name: componentA
  url: https://github.com/<MyOrganisation>/component-a.git

- type: git
  url: https://github.com/<MyOrganisation>/component-b.git
  branch: feature/new-gizmo

- type: git
  url: https://github.com/<MyOrganisation>/component-c.git
  tag: release/1.0.3

- type: git
  url: https://github.com/<MyOrganisation>/component-d.git
  instructions: sub-instructions.yaml

values:
- name: component-d.git
  value: 
  - name: component-e.git
    value: 
    - name: tag
      value: release/2.0.0.
```

It has the following fields:

| Attribute | Description |
| --- | --- |
| `stagingDirectory` |Relative directory where the dependencies will be located. Default is `submodules`. Individual dependencies will be located in a subfolder name matching their name. |
| `instructions` | List additional instruction sets of `ModelAssemblyInstructions` to be read. These can specify additional `instructions`, `dependencies`, or `values`. </lb> This allows modular construction of instruction sets, reusing existing patterns and structures but with different configurations to suit various purposes. |
| `instructions[].path` | Path to the additional instructions file. |
| `dependencies` | List of individual dependencies, with the following attributes: |
| `dependencies[].type` | Must be `git`. To enable future support of other types of repositories. |
| `dependencies[].name` | Name of the dependency. If not set, this will be inherited from final element of the URL. |
| `dependencies[].url` | URL of the dependency repository. |
| `dependencies[].tag \| .commit \| .branch` | Specify a particular point in the repository to checkout, by either a specific tag, commit, or branch (in that order of preference). If a branch is specified, it will be checked out at the current HEAD. If nothing is specified, the default branch will be checked out at the current HEAD. |
| `dependencies[].instructions` | Specify a `ModelAssemblyInstructions` within the dependency to continue a hierarchical build. |
| `values` | List to allows overwrite of variables within an instruction set at any level of hierarchy. |
| `values[].name` | Specify the name of the attribute to be overwritten. Can refer to an actual attribute, or the name of a dependency. |
| `values[].value` | Specify the value of the attribute. If `name` is the name of a dependency, this is expected to be another name-value pair which will be applied to that dependency. |

---

## Examples

See [examples](examples/readme.md).

---

## Contributing

Thanks for contributing! Please report bugs or raise a Pull Request to contribute.

## License

[MIT License](LICENSE)