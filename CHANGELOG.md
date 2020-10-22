# Change Log

## 1.1.0

- Upgraded glimmer-dsl-swt, glimmer-dsl-xml, and glimmer-dsl-css
- Fix issue with failing to configure samples for glimmer-dsl-swt since it does not support sample configuration anymore because it became automatic

## 1.0.0

- Upgraded to Glimmer DSL for SWT 4.17.0.0
- Made samples available via the `glimmer` command (e.g. glimmer sample:run[hello_video])
- `#toggle` method for video play/pause action (plays if paused and pauses if playing)
- Handle non-absolute files
- Validate video file and raise error if invalid
- Fast-Forward & Rewind
- Volume get, set, up, and down
- mute, unmute, muted?, and toggle_muted

## 0.1.3

- Fixed an issue with hooking widget observers via symbol instead of a string

## 0.1.2

- Upgraded to the glimmer-dsl-swt 0.4.1, glimmer-dsl-xml 0.1.0, and glimmer-dsl-css 0.1.0

## 0.1.1

- Upgraded to Glimmer 0.8.0 with a relaxed version requirement

## 0.1.0

- Initial version
