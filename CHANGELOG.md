# CHANGELOG

## [0.0.124] 2022-02-08
- CHANGED: Added in `DynamicRouteState` routes for the various status code

## [0.0.123] 2022-02-07
- CHANGED: Fix padding of buttons

## [0.0.122] 2022-02-06
- ADDED: Navigate action to launch URLs

## [0.0.120] 2022-02-06
- FIX: Action handling of list-view-switch

## [0.0.119] 2022-02-04
- FIX: Turn on/off flash-light in the QR Code scanner

## [0.0.118] 2022-02-02
- CHANGED: Improved logging in HTTP

## [0.0.116] 2021-12-29
- CHANGED: Added action handler on CircleAvatar

## [0.0.115] 2021-12-28
- ADDED: Add QRView for scanning QR codes
- FIXED: Remove the color from the embeded image

## [0.0.99] 2021-12-28
- ADDED: Added Center

## [0.0.97] 2021-12-27
- ADDED: Added QrImage

## [0.0.96] 2021-12-25
- ADDED: Added `color` and `iconColor` to button

## [0.0.95] 2021-12-21
- ADDED: Input of type `image` and `video` using [image_picker](https://pub.dev/packages/image_picker)
- FIXED: Button circular progress color

## [0.0.89] 2021-12-21
- CHANGED: Increase money size

## [0.0.88] 2021-12-15
- CHANGED: Use icon for keyboard DEL key

## [0.0.87] 2021-12-15
- FIXED: Use the numeric keyboard button size
- ADDED: ListView.separatorColor
- CHANGED: Remove the dropdown outline

## [0.0.86] 2021-12-15
- CHANGED: Decorate `Scaffold` with `GestureDetector` to remove focus from current input on tap out

## [0.0.85] 2021-12-14
- FIXED: Revert the form reset on navigation change
- CHANGED: Put the icon and message inside to `Column` instead of a `Row`

## [0.0.84] 2021-12-14
- CHANGED: Reset form state on navigation changed

## [0.0.83] 2021-12-13
- CHANGED: Added custom actions

## [0.0.82] 2021-12-13
- FIX: Add UTF-8 encoding for the `Content-Type` and `Accept` headers

## [0.0.81] 2021-12-13
- CHANGE: await for camera to upload picture
- FIX: Improve handling of HTTP upload response

## [0.0.77] 2021-12-12
- FIXED: Reset the amount on navigation pop

## [0.0.76] 2021-12-06
- ADDED: Added in analytics.dart callback method for tracing

## [0.0.73] 2021-12-06
- FIX: Disable audio for CameraController
- CHANGED: Default camera = back

## [0.0.72] 2021-12-06
- FIX: Image in CircularAvatar not clipped

## [0.0.71] 2021-12-06
- ADDED: Camera support
- ADDED: Global variable `sduiProgressIndicator`

## [0.0.62] 2021-11-21
- FIXED: Dialog box cause the app to freeze

## [0.0.61] 2021-11-21
- ADD: Add component for supporting tab views: `Tab`, `TabBar`, `TabBarView`
- CHANGED: Add `bottom` to `AppBar`
- CHANGED: Add `leading` and `trailing` in `ListView`

## [0.0.60] 2021-11-26
- FIXED: Icon color in button

## [0.0.59] 2021-11-26
- ADDED: Icon into Button

## [0.0.58] 2021-11-26
- ADDED: Improve dialog box

## [0.0.56] 2021-11-25
- ADDED: Add SDUIAnalytics for integrating with analytics

## [0.0.55] 2021-11-25
- ADDED: Wrapper error and loading page in Scaffold
- ADDED: Rename global variable `routeObserver` to `sduiRouteObserver`

## [0.0.54] 2021-11-24
- ADDED: Error state global variable

## [0.0.53] 2021-11-24
- ADDED: Loading state global variable

## [0.0.52] 2021-11-24
- FIXED: Fix PIN backspace on empty text

## [0.0.51] 2021-11-24
- FIXED: Fixed the value

## [0.0.50] 2021-11-24
- ADDED: Add MoneyWithSlider

## [0.0.49] 2021-11-23
- CHANGED: ListTile now support padding
- CHANGED: Set the size of ListTile trailing and leading icons

## [0.0.48] 2021-11-21
- ADDED: Support Action.share
- ADDED: Added dependencies to [share_plus](https://pub.dev/packages/share_plus)

## [0.0.47] 2021-11-20
- ADDED: Support for CircleAvatar

## [0.0.46] 2021-11-18
- CHANGED: Improve command handling

## [0.0.45] 2021-11-17
- FIX: Fix the keyboard DELETE color

## [0.0.44] 2021-11-14
- ADDED: SDUIWidget.id

## [0.0.43] 2021-11-14
- FIXED: Reload screen on pop

## [0.0.42] 2021-11-14
- FIXED: Fix `Money.numberFormat`

## [0.0.41] 2021-11-14
- FIXED: Fix NPE with `AppBar.automaticallyImplyLeading`

## [0.0.40] 2021-11-13
- ADDED: component `MoneyWithKeyboard`
- CHANGED: Changed border of DropdownButton

## [0.0.39] 2021-11-11
- CHANGED: Replaced `intl_phone_field` by `intl_phone_number_input`

## [0.0.38] 2021-11-08
- CHANGED: Center app-bar header
- CHANGED: Improve logging of HTTP errors
- CHANGED: Add SDUIButton.stretched

## [0.0.37] 2021-11-08
- ADDED: Divider

## [0.0.36] 2021-11-08
- CHANGED: Add into Row/Column properties: `mainAxisAlignment` `crossAxisAlignment`and `mainAxisSize`
- CHANGED: Add support for `Scaffold.backgroundColor`
- CHANGED: Improve HTTP status logging

## [0.0.35] 2021-11-08
- FIXED: Fix deserialization of AppBar actions

## [0.0.34] 2021-11-08
- CHANGED: Log status code

## [0.0.33] 2021-11-07
- CHANGED: Add more properties to AppBar

## [0.0.32] 2021-11-07
- ADDED: `MoneyText`

## [0.0.31] 2021-11-06
- FIX: Fix response headers

## [0.0.30] 2021-11-07
- ADDED: LoggerFactory for improving logging output
- FIXED: send request headers
- FIXED: add more logs

## [0.0.29] 2021-11-06
- FIXED: Use `Uri.encodeComponent` insteald of `Uri.encodeFull`

## [0.0.28] 2021-11-06
- FIXED: numeric keyboard buttons

## [0.0.26] 2021-11-06
- ADDED: parameters to actions
- CHANGED: fix dimension of numeric keyboard based on button width

## [0.0.25] 2021-11-05
- FIXED: Prevent overflow when keyboard appear

## [0.0.24] 2021-11-04
- ADDED: Log all HTTP transactions

## [0.0.23] 2021-11-02
- ADDED:  `Action.replacement`
- CHANGED: Replace action type `Screen` to `Route`
- CHANGED: Improvement of keyboard layout

## [0.0.22] 2021-11-02
- CHANGED: countries list

## [0.0.21] 2021-11-02
- CHANGED: SDUIInput support countries for phone input
- CHANGED: SDUIPinWidthKeyboard

## [0.0.20] 2021-10-14
- CHANGED: Remove log pollution
- CHANGED: Add support for URL icon

## [0.0.19] 2021-10-13
- ADDED: Add Dropdown
- CHANGED: Remove logs

## [0.0.18] 2021-10-12
- FIXED: NPE on parsing AppBar

## [0.0.17] 2021-10-11
- ADDED: IconButton
- ADDED: AppBar
- CHANGED: Improved logging when unable to load a route content
- CHANGED: Make ListItemSwitch a form field
- CHANGED: Make RadioGroup a form field

## [0.0.16] 2021-10-10
- CHANGED: Deployment with Github Actions

## [0.0.15] 2021-10-10
- CHANGED: Deployment with Github Actions

## [0.0.14] 2021-10-10
- CHANGED: Update documentation in README

## [0.0.13] 2021-10-09
- ADDED: HttpInterceptor to provide functionality to intercept all http transactions
- ADDED: Support for SafeArea

## [0.0.12] 2021-10-06
- ADDED: Show icons in dialog

## [0.0.11] 2021-10-06
### Added
- Support for dialog

## [0.0.10] 2021-10-05
- CHANGED: Container alignment constants

## [0.0.9] 2021-10-05
- ADDED: Button padding
- ADDED: Http.clientId
- CHANGED: All HTTP interactions used POST

## [0.0.8] 2021-10-05
- CHANGED: Initialize the phone input with current country code
- CHANGED: Always expand buttons on X axis.
- CHANGED: Support `ElevatedButton`, `TextButton` and `OutlinedButton`
- FIXED: `Flexible` serialization

## [0.0.6] 2021-10-04
- ADDED: Support for `Page`

## [0.0.5] 2021-10-01
- ADDED: Support for `PageView`
- ADDED: Support for `Spacer`
- CHANGED: Support in `SDUIInput` for `url`, `email` and `number`

## [0.0.4] 2021-09-30
- ADDED: Add phone number input
- CHANGED: Renamed `SDUInput` to `SDUIInput`

## [0.0.3] 2021-09-30
- ADDED: Add date and time pickers

## [0.0.2] 2021-09-29
- CHANGED: House keeping changed

## [0.0.1+1] 2021-09-29
- ADDED: Initial
