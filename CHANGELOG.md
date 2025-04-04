# Change Log
All notable changes to this project will be documented in this file.
`ADUtils` adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added

- Add support for Xcode 16 synchronized folders
- Add support for Swift Packages
    - Add new optional variable nammed "project_type" which accepts 2 values: "xcode" and "spm". When missing ccios use "xcode" by default.
    - When "project_type" is set to "spm" ccios will not try to update a pbxproj and will only generate files.
    - When "project_type" is set to "spm" multi target definition is no longer supported for generated files, as this is not supported by SPM.
    - When generating files for an spm project, the target name in the header is either: the target defined in the template variables, the target defined in `.ccios.yml`, or it will guess the name of the target when your package uses the standard naming scheme of: "Sources/<target_name>/".

## [5.1.0]

### Changed

- Target variable is now optional, an empty string or an unset value will use the first target of the project. This change allows templates to not overrides global target settings in `.ccios.yml`
- When multiple targets are provided for a file, `{{project_name}}` will now be replaced by the name of the project instead of the name of the first target
- `@MainActor` has been added to relevent files in Coordinator and Presenter templates to improve Swift 6 support
- dependency provider snippets has been updated to handle Swift 6 issue (see [this issue](https://github.com/Swinject/Swinject/issues/571) for why this is required)

## [5.0.0]

This release is an entire rewrite of the templating system, allowing customization of template and settings.

### Added

- New templating system that allows definition of custom templates per project
- A template can now declare multiple CLI arguments and flags
- Generated files can be added to multiple targets
- The base_path group and target can be configured independently for each generated file if needed.
- Add validation that each variable used in a mustache file is provided by the template. The default provided variables are: `filename`, `lowercase_filename`, `project_name`, `full_username` and `date`
- List of known templates is available using `ccios --help`

### Changed

- Default templates has been migrated to the new format
- Configuration file (`.ccios`) format has been changed
- Command line invocation has changed:
    - `ccios -p Example [-d]` is now `ccios presenter Example [-d]`
    - `ccios -c Example [-d]` is now `ccios coordinator Example [-d]`
    - `ccios -i Example [-d]` is now `ccios interactor Example`
    - `ccios -r Example [-d]` is now `ccios repository Example`
- Some default provided mustache variables have been renamed:
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
