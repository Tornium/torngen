# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Fixed
- \[Elixir\] Fixed representation and parsing of non-required object keys
- \[Python\] Fixed representation and parsing of nested `allOf` code generation
- \[Python\] Fixed parsing of the `typing.Any` representation

## 0.1.5 - 2025-12-05
### Added
- \[Elixir\] Added code generation for `oneOf` (#1)

### Fixed
- \[Elixir\] Fixed missing validation and parsing for enums

## [0.1.4] - 2025-09-23
### Added
- Added parsing for objects with non-required keys

### Fixed
- Fixed parsing of embedded objects
- Fixed representation of untyped objects (#8)

## [0.1.3] - 2025-07-31
### Added
- Added python code generation

### Changed
- Changed newline characters in path to use space characters
- Changed inline Elixir object code generation to use atoms instead of strings for keys

### Fixed
- Fixed unnecessary required `:out_dir` configuration for compile-time

## [0.1.2] - 2025-07-04
### Fixed
- Fixed priv loading for CI/CD

## [0.1.1] - 2025-07-04
### Fixed
- Fixed missing reason in Elixir generation of `@deprecated` tags for parameters
- Fixed missing `validate?/2` of `Torngen.Client.Schema` for the `:object`, `:one_of`, and `:all_of` types (#3)

### Removed
- Removed deprecated `normalize_string`

## [0.1.0] - 2025-05-31
### Added
- Added Torn APIv2 Open API specification parsing
- Added Torn APIv2 code generation for Elixir

