# ccios
Xcode File Generator for Clean Code architecture

# How to install
```
gem install ccios
```

To build it from source:
```
cd ccios
gem build ccios.gemspec
gem install ./ccios-x.x.x.gem
```

To run the tests run:
```bundle exec rake test```

# How to use

Go to your `.xcodeproj` folder `cd /paht/to/my/xcodeproj`.
Then generate files with prefix `Example`:

```bash
ccios <template_name> [template_arguments...] [template_options]
```

The list of known templates is visible using the following command:
```bash
ccios --help
```

Generated templates can be found [here](https://github.com/fabernovel/ccios/tree/master/lib/ccios/templates)

## Default templates

### `presenter`

```bash
ccios presenter Example [-d]
```

This generates 4 files: `ExampleViewController`, `ExampleViewContract`, `ExamplePresenter`, `ExamplePresenterImplementation`. If the `-d` option is supplied the protocol `ExamplePresenterDelegate` will be generated.

What's more it prints the code you need to add to `DependencyProvider.swift` and `PresenterAssembly.swift` for dependency injection.

The following structure is created for you in the Xcode project:

```
.
+-- App/
|   +-- Example/
|   |   +-- UI/
|   |   |   +-- View/
|   |   |   +-- ViewController/
|   |   |   |   +-- ExampleViewController
|   |   |   +-- ExampleViewContract
|   |   +-- Presenter/
|   |   |   +-- ExamplePresenter
|   |   |   +-- ExamplePresenterImplementation
|   |   +-- Model/
```

### `interactor`

```bash
ccios interactor Example
```

This generates 2 files: `ExampleInteractor` and `ExampleInteractorImplementation`.

What's more it prints the code you need to add to `InteractorAssembly.swift` for dependency injection.

The following structure is created for you in the Xcode project:

```
.
+-- Core/
|   +-- Interactor/
|   |   +-- ExampleInteractor/
|   |   |   +-- ExampleInteractor
|   |   |   +-- ExampleInteractorImplementation
```

### `repository`

```bash
ccios repository Example
```

This generates 2 files: `ExampleRepository` and `ExampleRepositoryImplementation`.

What's more it prints the code you need to add to `RepositoryAssembly.swift` for dependency injection.

The following structure is created for you in the Xcode project:

```
.
+-- Core/
|   +-- Data/
|   |   +-- Example
|   |   |   +-- ExampleRepository
+-- Data/
|   +-- Example
|   |   +-- ExampleRepositoryImplementation
```

### `coordinator`

```bash
ccios coordinator Example [-d]
```

This generates one file: `ExampleCoordinator`. If the `-d` option is supplied the protocol `ExampleCoordinatorDelegate` will be generated.

The following structure is created for you in the Xcode project:

```
.
+-- Coordinator/
|   +-- ExampleCoordinator
```

## Configuration

Each project is different. You can configure the available templates that can be used 
You can configure the groups to use in the xcodeproj for the new files.

Create a file `.ccios.yml` at the root of your project.

An empty config file is valid as all properties are optional.

```yml
# Path to an additional collection of templates. [Optional]
# Templates present in this folder will be available. If the collection use the same name as a default template, it will override it.
templates_collection: ccios/templates

# Global overrides of variables [Optional]
variables:
  project: Project.xcodeproj
  target: SomeDefaultTarget

# Per template variables override
templates_config:
  # Use the template name (in template.yml) to specify overrides on this template:
  TEMPLATE_NAME:
    # This overrides the default template variables
    variables:
      project: "Project.pbxproj"
      # You can specify multiple target for generated files.
      target: 
        - SomeTarget
        - SomeOtherTarget
        - ThirdTarget
    # Per element variable override
    elements_variables:
      # This overrides the default variables for the element named "ELEMENT_NAME_1"
      ELEMENT_NAME_1:
        base_path: Core/Data
        target: Core
      ELEMENT_NAME_2:
        base_path: Data
        target: Data
  # Another template variable override
  presenter:
    variables:
      base_path: MyProject/App
    elements_variables:
      repository:
        base_path: "Core/Data"
  coordinator:
    variables:
      base_path: MyProject/Coordinator
```

*Note*: The path of the new files will be infered from the path of the group. It works with *Group with folder* and *Group without folder* in Xcode.

## Template definition

Default templates can be found [here](https://github.com/fabernovel/ccios/tree/master/lib/ccios/templates), and can be used to see what is possible.

A template is a folder containing a file `template.yml` next to all templating files that will be used during generation.
Example for the default Interactor template:
```
Interactor/
    template.yml
    interactor.mustache
    interactor_assembly.mustache
    interactor_implementation.mustache
```

### `template.yml` format

```yml
# name of the template to use in the CLI. [required]
name: "custom_template"
# description of the template. [optional]
description: "Custom template definition"
# List of the parameters that will be given to the file templates. [required]
# The parameters can be used in template files, and in file path.
parameters:
  # Use this to represent a string argument parameter in the CLI
  # By default the argument will be passed to template renderer under the name "name", to use another name, specify a `template_variable_name`
  - argument: "name" 
    # Description used in the help command. [Optional]
    description: "name argument description"
    # When present, the argument will be usable in templates under the provided name. [Optional]
    template_variable_name: "in_template_variable_name"
    # When present, will remove the provided suffix from the argument given. Example "MySuffix" will be tranformed into "My". [Optional]
    removeSuffix: "Suffix"
    # When present, the lowercased argument will be usable in templates under the provided name. [Optional]
    lowercased_variable_name: "name_of_the_lowercased_variable"
  # Use this to represent a flag parameter in the CLI, the flag will be provided to templates as `true` when present in the executed command.
  - flag: "long_name"
    # The short name of this flag to use on CLI. [optional]
    short_name: "n"
    # Description used in the help command. [Optional]
    description: "Description for the long_name flag"
    # When present, the argument will be usable in templates under the provided name. [Optional]
    template_variable_name: "in_template_flag_name"
# List of templates variables that is used to generate files in an xcode project. [Optional]
# Those variables can be overridden in config file, see section "Variable hierarchy" for more informations.
variables:
  # The name of the xcode project. "*.xcodeproj" will use the first it finds. [required]
  project: "*.xcodeproj"
  # The base path used to generate an element. This variable must be defined once here, or on each elements below.
  base_path: "path/to/base_group"
  # The target in which files are added. Can be a string, a list of strings, or an empty string. This variable must be defined once here, or on each elements below. If an empty string is provided, it will use the first target found in the Xcode project. If present it will override the global default target.
  target: "SomeTarget"
# List of generated elements. [Required]
# Each element can be a file (using `file`), or an empty folder (using `group`)
generated_elements:
    # Path from the `base_path` variable where the file will be generated
  - file: "{{ name }}/{{ name }}File.swift"
    # This name identifies this generated file to allow variable overrides in config file. [Required]
    name: "file"
    # The template specifies the name of template that will be used from `template_file_source`
    template: "file"
    # List of default element variable. [Optional]
    variables: {}
    # Path from the `base_path` variable where the directory will be generated
  - group: "{{ name }}/group"
    # This name identifies this generated file to allow variable overrides in config file. [Required]
    name: "group"
    # List of default element variable. [Optional]
    variables:
      - base_path: "path/override/to/base_group"
# List of code snippets that will be printed by the CLI after the generation of files. [Optional]
code_snippets:
    # The name will be used in the printed line "Add this snippet to FilenameInWhichTheSnippetIsExpected" before the generated code snippet.
    # This name will also be given to the snippet template under the variable `filename` and `lowercased_filename`. [Required]
  - name: FilenameInWhichTheSnippetIsExpected
    # The template specifies the name of template that will be used from `template_file_source`. [Required]
    template: "file_snippets"
# List of templating files used for element generation or code snippets. [Required]
# The key is used as an identifier in `generated_elements` or `code_snippets`, the value is the path from the template directory.
template_file_source: 
  file: "file.mustache"
  file_snippets: "file_snippets.mustache"
```

### Variable hierarchy

In `template.yml`
```yml
# [...]
variables:
  # -> Default templates variables
generated_elements:
  - name: element_name
    # [...]
    variables:
      # -> Default Element variables
```

In `.ccios.yml`
```yml
variables:
  # -> Config Global variables
templates_config:
 repository:
   variables:
     # -> Config Template variables
   element_variables:
     element_name:
       # -> Config Element variables
```

Templates will use variables in this order (first in this list is used):
- Config Template variables
- Default templates variables
- Config Global variables

Element will use variables in this order (first in this list is used): (For files, groups and code snippets)
- Config Element variables
- Default Element variables
- Config Template variables
- Default templates variables
- Config Global variables
