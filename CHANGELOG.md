# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Added python code generation

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

