<div align="center">

# Model Assembly Language

[The Problem](#what-problem-does-this-solve) •
[The Approach](#what-does-this-do) •
[Quick Guide](#quick-guide) •
[Detailed Guide](#detailed-guide) •
[Examples](#examples) •
[Contributing](#contributing) •
[License](#license)


</div>

---

## What Problem does this Solve?

* Complex systems require complex models.
* Complex models frequently require complex organisations.
* Integrating model hierarchies is challenging. 
* Balancing rigour and flexibility requires compromise.
* Git submodules can be obscure and difficult.


## What does this do?

* The Model Assembly Lanuage `MAL` is a structured language inspired by [Helm](https://helm.sh/) for use with [MATLAB](https://uk.mathworks.com/products/matlab.html).
* It enables a user to specify the dependencies for a project in a flexible yaml-based approach.
* Dependencies can cascade, allowing hierarchical expansion of a model structure.
* The `MAL` enables precious control of the configuration of model hierachy, including branch, tag, and commit referencing, including injection of a lower-level configuration.

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

Then, fetch your dependencies using the following:

```matlab
mal.fetchInstructionSet("mal.yaml")
```

## Detailed Guide

An Instruction set is a `.yaml` file. It can be in any project directory and have any name. When loaded, it will be translated into a [`mal.ModelAssemblyInstructions`](src/%2Bmal/ModelAssemblyInstructions.m) object.

Full example:

```yaml
stagingDirectory: project/submodules

instructions:
- instructions/assembly.yaml
- instructions/config.yaml

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

### `stagingDirectory`

Relative directory where the dependencies will be located. Default is `submodules`. Individual dependencies will be located in a subfolder name matching their name.

### `instructions`

List additional instruction sets of `ModelAssemblyInstructions` to be read. These can specify additional `instructions`, `dependencies`, or `values`.

This allows modular construction of instruction sets, reusing existing patterns and structures but with different configurations to suit various purposes.

### `dependencies`

List of individual dependencies, with the following attributes:

### `dependencies[].type`

Must be `git`. To enable future support of other types of repositories.

### `dependencies[].name`

Name of the dependency. If not set, this will be inherited from final element of the URL.

### `dependencies[].url`

URL of the dependency repository.

### `dependencies[].tag | .commit | .branch`

Specify a particular point in the repository to checkout, by either a specific tag, commit, or branch (in that order of preference). If a branch is specified, it will be checked out at the current HEAD. If nothing is specified, the default branch will be checked out at the current HEAD.

### `dependencies[].instructions`

Specify a `ModelAssemblyInstructions` within the dependency to continue a hierarchical build.

### `values`

Allows overwrite of variables within an instruction set at any level of hierarchy. To modify an instruction:

1. Specify the dependency it belongs to by name.
2. If the dependency is at a lower level of the hierarchy, specify the full route.
3. Specify the name of the attribute to modify.
4. Specify the new value of the attribute.

---

## Examples

See [examples](examples/readme.md).

---

## Contributing

Thanks for contributing! Please report bugs or raise a Pull Request to contribute.

## License

[MIT License](LICENSE)