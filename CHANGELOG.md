# CHANGELOG

## [0.0.52] 2021-11-24
### Fixed
- Fix PIN backspace

## [0.0.51] 2021-11-24
### Fixed
- Fixed the value

## [0.0.50] 2021-11-24
### Added
- Add MoneyWithSlider

## [0.0.49] 2021-11-23
### Update
- ListTile now support padding
- Set the size of ListTile trailing and leading icons

## [0.0.48] 2021-11-21
### Added
- Support Action.share
- Added dependencies to [share_plus](https://pub.dev/packages/share_plus)

## [0.0.47] 2021-11-20
### Added
- Support for CircleAvatar

## [0.0.46] 2021-11-18
### Updated
- Improve command handling

## [0.0.45] 2021-11-17
### Updated
- Fix the keyboard DELETE color

## [0.0.44] 2021-11-14
### Added
- id to all widgets

## [0.0.43] 2021-11-14
### Fixed
- Reload screen on pop

## [0.0.42] 2021-11-14
### Fixed
- Fix `Money.numberFormat`

## [0.0.41] 2021-11-14
### Fixed
- Fix NPE with `AppBar.automaticallyImplyLeading`

## [0.0.40] 2021-11-13
### Added
- component `MoneyWithKeyboard`
### Updated
- Changed border of DropdownButton

## [0.0.39] 2021-11-11
### Updated
- Replaced `intl_phone_field` by `intl_phone_number_input`

## [0.0.38] 2021-11-08
### Updated
- Center app-bar header
- Improve logging of HTTP errors
- Add SDUIButton.stretched

## [0.0.37] 2021-11-08
### Added
- Add `Divider`

## [0.0.36] 2021-11-08
### Modified
- Add into Row/Column properties: `mainAxisAlignment` `crossAxisAlignment`and `mainAxisSize`
- Add support for `Scaffold.backgroundColor`
- Improve HTTP status logging

## [0.0.35] 2021-11-08
### Fixed
- Fix deserialization of AppBar actions

## [0.0.34] 2021-11-08
### Modify
- Log status code

## [0.0.33] 2021-11-07
### Modify
- Add more properties to AppBar

## [0.0.32] 2021-11-07
### Added
- Added `MoneyText`

## [0.0.31] 2021-11-06
### Fixed
- Fix response headers

## [0.0.30] 2021-11-07
### Add
- LoggerFactory for improving logging output
### Fixed
- send request headers
- add more logs

## [0.0.29] 2021-11-06
### Fixed
- Use `Uri.encodeComponent` insteald of `Uri.encodeFull`

## [0.0.28] 2021-11-06
### Fixed
- numeric keyboard buttons

## [0.0.26] 2021-11-06
### Added
- parameters to actions
### Updated
- fix dimension of numeric keyboard based on button width

## [0.0.25] 2021-11-05
### Fixed
- Prevent overflow when keyboard appear

## [0.0.24] 2021-11-04
### Added
- Log all HTTP transactions

## [0.0.23] 2021-11-02
### Added
- Add `Action.replacement`
### Updated
- Replace action type `Screen` to `Route`
- Improvement of keyboard layout

## [0.0.22] 2021-11-02
### Fixed
- countries list

## [0.0.21] 2021-11-02
### Updated
- SDUIInput support countries for phone input
- SDUIPinWidthKeyboard

## [0.0.20] 2021-10-14
### Changed
- Remove log pollution
- Add support for URL icon

## [0.0.19] 2021-10-13
### Fixed
- Add Dropdown
- Remove logs

## [0.0.18] 2021-10-12
### Fixed
- NPE on parsing AppBar

## [0.0.17] 2021-10-11
### Added
- IconButton
- AppBar
### Changed
- Improved logging when unable to load a route content
- Make ListItemSwitch a form field
- Make RadioGroup a form field

## [0.0.16] 2021-10-10
### Changed
- Deployment with Github Actions

## [0.0.15] 2021-10-10
### Changed
- Deployment with Github Actions

## [0.0.14] 2021-10-10
### Changed
- Update documentation in README

## [0.0.13] 2021-10-09
### Added
- Add HttpInterceptor to provide functionality to intercept all http transactions
- Add support for SafeArea

## [0.0.12] 2021-10-06
### Added
- Show icons in dialog

## [0.0.11] 2021-10-06
### Added
- Support for dialog

## [0.0.10] 2021-10-05
### Changed
- Container alignment constants

## [0.0.9] 2021-10-05
### Added
- Button padding
- Http.clientId
### Changed
- All HTTP interactions used POST

## [0.0.8] 2021-10-05
### Fixed
- `Flexible` serialization
### Changed
- Initialize the phone input with current country code
- Always expand buttons on X axis.
- Support `ElevatedButton`, `TextButton` and `OutlinedButton`

## [0.0.6] 2021-10-04
### Added
- Add support for `Page`

## [0.0.5] 2021-10-01
### Added
- Add support for `PageView`
- Add Support for `Spacer`
### Changed
- Add support in `SDUIInput` for `url`, `email` and `number`

## [0.0.4] 2021-09-30
### Added
- Add phone number input
### Changed
- Renamed `SDUInput` to `SDUIInput`

## [0.0.3] 2021-09-30
### Added
- Add date and time pickers

## [0.0.2] 2021-09-29
### Added
- House keeping changed

## [0.0.1+1] 2021-09-29
### Added
- Initial
