# Change Log
All notable changes to this project will be documented in this file.
`ADUtils` adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

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
