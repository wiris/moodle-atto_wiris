# Changelog

## MathType Moodle plugin for Atto

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Last release of this plugin is 7.26.1 - YYYYMMDD.

## [Unreleased]
- ...

## v7.26.1 - YYYYMMDD
- Fixes 'atto wiris buttons do not work with multilang2' ([#72](https://github.com/wiris/moodle-atto_wiris/issues/72)).
- Upgrade Third-Party Library 'MathType Web Integration JavaScript SDK'
  to latest version, v1.5.1.
- Include a test to validate the Multilang2 compatility
- Improve README.md.

## v7.26.0 - 20210506
- [KB-7506]: Fix & upgrade TravisCI job configuration.
  - Support for PHP7_3 and PHP7_4.
  - Support for Moodle3_10 and Moodle3_11.
  - Enable `fast_finish` option.
  - Don't use the `blackboard-open-source` distro until it's fixed.
- Add support for local rebuild and lint Moodle tasks.
- Update project documentation by improving the main `README` file.
- Start using `CHANGES` file as changelog.