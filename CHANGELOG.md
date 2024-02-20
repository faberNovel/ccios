# Change Log
All notable changes to this project will be documented in this file.
`ADUtils` adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

This release is an entire rewrite of the templating system, allowing customization of template and settings.

### Added

- New templating system that allows definition of custom templates per project
- A template can now declare multiple CLI arguments and flags
- Generated files can be added to multiple targets
- The base_path group and target can be configured independently for each generated file if needed.
- Add validation that each variable used in a mustache file is provided by the template. The default provided variables are: `filename`, `lowercase_filename`, `project_name`, `full_username` and `date`
- List of known templates is available using `ccios --help`

### Removed

- There is no longer an automatic suffix removal from the argument passed in the CLI. Example: `ccios presenter ExamplePresenter` will generate a file named: `ExamplePresenterPresenter`

### Changed

- Default templates has been migrated to the new format
- Configuration file (`.ccios`) format has been changed
- Command line invocation has changed:
    - `ccios -p Example [-d]` is now `ccios presenter Example [-d]`
    - `ccios -c Example [-d]` is now `ccios coordinator Example [-d]`
    - `ccios -i Example [-d]` is now `ccios interactor Example`
    - `ccios -r Example [-d]` is now `ccios repository Example`
- Some default provided mustache variables has been renamed:
    - `name` is now `filename`
    - `lowercased_name` is now `lowercased_filename`

## [4.1.0]

### Added
- Allow user to overload templates with local version thanks to the new config parameter in `.ccios.yml`

## [4.0.2]

### Fixed

- Do not duplicate suffix if already present in the command name

## [4.0.1]

### Fixed

- Do not generate new groups with name if using folder references

## [4.0.0]

### Added
- Use `ADCoordinator` dependency in coordinator files

### Fixed
- Use `active_support` instead of `rails` dependency
- Add dev dependencies

## [3.0.0]

### Fixed
- Use `ApplicationDependencyProvider` in Coordinator
  - Updated by [Denis Poifol](https://github.com/denisPoifol) in Pull Request [#10](https://github.com/felginep/ccios/pull/10)

## [2.3.1]

### Fixed
- Import `Core` in Repository implementations
  - Updated by [Hervé Béranger](https://github.com/hberenger) in Pull Request [#11](https://github.com/felginep/ccios/pull/11)

## [2.3.0]

### Added
- Add possibilty to specify target in `.ccios.yml`

## [2.2.0]

### Added
- Create configuration with optional `.ccios.yml` file
